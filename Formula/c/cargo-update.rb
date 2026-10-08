class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v22.1.1.tar.gz"
  sha256 "570d009f6ddd83d54ea478b63f369e08617feddb7119a9cb1d5c6a050d213c28"
  license "MIT"
  revision 1
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "032dc9f0c810e4be4158d8afe7b3b9c6274730b459170783b85a978e7377c6e7"
    sha256 cellar: :any, arm64_tahoe:       "56f5bfc5c1b6063b0098e8ec20710ae4c39f602772e25d987add317755aa5fa1"
    sha256 cellar: :any, arm64_sequoia:     "4c801fd3e601f078fcd3eef25f6078cd2237a045a9a8d234caa5994ea5272e81"
    sha256 cellar: :any, arm64_linux:       "56603352a0a90fa491ae645c5349884f843fd20b168b0c8389e6c306e376982e"
    sha256 cellar: :any, x86_64_linux:      "c554036b44b1844cabb94aa51a53588185cd75b215bc6424d239b91a0e2c7a64"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("cargo install-update --version")

    output = shell_output("cargo install-update -a")
    assert_match "No packages need updating", output
  end
end
