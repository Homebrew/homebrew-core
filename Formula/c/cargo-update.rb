class CargoUpdate < Formula
  desc "Cargo subcommand for checking and applying updates to installed executables"
  homepage "https://github.com/nabijaczleweli/cargo-update"
  url "https://github.com/nabijaczleweli/cargo-update/archive/refs/tags/v18.1.1.tar.gz"
  sha256 "764cb9b6657fc0eca39479cd0c25c247e18c62e3bb278edec4dfcf2eda626c7c"
  license "MIT"
  head "https://github.com/nabijaczleweli/cargo-update.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5569dfa80bbe593fe7d57ec8606318172b7ff37069763b790be9f8185e62d126"
    sha256 cellar: :any,                 arm64_sequoia: "8c87cd2c91339697c3f3bc7bebacc3a35734ce392079abcfcdde4974b5fc4c22"
    sha256 cellar: :any,                 arm64_sonoma:  "390978799d026193d544e3bc3414228402f92c0b17919f0a5a6bc04841c77432"
    sha256 cellar: :any,                 sonoma:        "0d055d98a8329702942537f5fd0b9a0682e00f3b775b753f20bded9f24303f63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7226bf6277cd6bb74da2cb0bf3051314e89e223bdebe1b8e38d3a34a50ac4a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7caf715ab9ce6a3bf47e55aeca020b658aa5c29ecea0d2b32b9851d194d8c36"
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
