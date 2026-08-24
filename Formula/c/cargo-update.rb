class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v22.1.1.tar.gz"
  sha256 "570d009f6ddd83d54ea478b63f369e08617feddb7119a9cb1d5c6a050d213c28"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc37d26a3b49d4ed4cc8636df82ec00da355f4c0e76ec568fec573ea24318c78"
    sha256 cellar: :any, arm64_sequoia: "da3f8309f3176bf673fcad56a218a70b4a68d9919a3efdebf0851ef0fdf060ef"
    sha256 cellar: :any, arm64_sonoma:  "0c181e563dfd1dfab97f8f4a14eb80b622d100e4a634144584e95f213232126a"
    sha256 cellar: :any, sonoma:        "73dde76bde9afdc0708ee3bee3747abbf149dd19a7fb006e592a745b09fa11e2"
    sha256 cellar: :any, arm64_linux:   "deaa48c43f8164dfc861ccf4f92e0f7f41026a2a700f26c75363cbfeaf57f156"
    sha256 cellar: :any, x86_64_linux:  "58f512405ea1b3c54bc87be9bc256d043ba8fdf0d29a7932092841191c34f2b1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("cargo install-update --version")

    output = shell_output("cargo install-update -a")
    assert_match "No packages need updating", output
  end
end
