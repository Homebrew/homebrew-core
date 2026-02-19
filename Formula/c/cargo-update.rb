class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v18.0.0.tar.gz"
  sha256 "cfa56d6c5fb2d7d1536efb4765031731fe70bf1a8246757a7a9d6a4a046e640f"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "789aabcffbe092ce47d9ec1f2f1da1f2d5bde575df3500ac1753da3fccba174b"
    sha256 cellar: :any,                 arm64_sequoia: "4095a439b598d9c0576a920c8152e604965816bfee96d6d0a9ce899b64bea724"
    sha256 cellar: :any,                 arm64_sonoma:  "0e47ffa9b7457d3522b8581166eb1624d50e8048a7950aacad8d5fbe117fff45"
    sha256 cellar: :any,                 sonoma:        "5225e1e62f91b7ee2d496f0892789aee7ff69934c75de0047ead6c330fa64b07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bdf5129e7fce8bb7674fcc1328dc9308c8e1a97b0b0764261e95b497e3622c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f7420561d07c9bfae1019447e8a1cc713c4a094d3e37e43c75d009153c99df"
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
