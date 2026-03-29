class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v19.0.0.tar.gz"
  sha256 "1937584fc78fa340e63b0d8e5e26becbcda996fd2a97f7f75fc5fa3020689a3e"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e52a495839250cc5e180b466e01505bef8056e66946331c6c00baa8e196d8eae"
    sha256 cellar: :any,                 arm64_sequoia: "f2cd85a0da9c9536e855fcb8182c96b4247a1ea57ab9c51c235948762e680b4f"
    sha256 cellar: :any,                 arm64_sonoma:  "e42998e8a0de79885c60d509855e450c9af4b3a32976036bded0f856ac94aa10"
    sha256 cellar: :any,                 sonoma:        "e49d7150139efd348e152d29f12d0c1dca62734ecf3821503ddb996d7c23bd15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f44d4fba414d0810aed74cbd986aa62d6417f60b55ca7f2bd7ea45f19eb5f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb15663e791851f7effb309175f65f088a0fee4b0c509b2fcc9bf8a094cac544"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
