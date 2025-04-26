class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v16.3.0.tar.gz"
  sha256 "f6a87615d72db3f1068aef2ad383813a96238c4963f6498c675c555a32e95bd3"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fac5a0bbdabd219af1a3b8362a4d923258cb7ed8854fc3ee6024ea010ecdd071"
    sha256 cellar: :any,                 arm64_sonoma:  "25c2875557d1656e2e5c99d23d0582a84de3631733c582064028e8348d7224b4"
    sha256 cellar: :any,                 arm64_ventura: "62375ed3e54f4d5a1d9f8dfc1abaf0d5e5b9a839f4a7f5bc3223bd6d38ef714f"
    sha256 cellar: :any,                 sonoma:        "7a2a23e55a4f684351c19f13ac8b965ac0854fc9686e6bacc13de5ab958460fa"
    sha256 cellar: :any,                 ventura:       "f57d7c2c979d343bb5e725c50de39026f8644e55eed9f00f3126761d502f4ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c96a062dcaac5f63296612da05613264362545c7c4e7f47fd697f36a88d03f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e23607c021b9163f0f903a3eac5f3545379fb1ed745d65a161477aae1e27dc2a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
