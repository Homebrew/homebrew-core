class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://github.com/crev-dev/cargo-crev"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "f8413baf3dc420d7cd217f8330dc6665e3e8ed87312c1d75fde3e6afbe84b6a3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "671bd59aa7ba7b26c97bb92291efac3af6775805a740784835bd12ddd3da7470"
    sha256 cellar: :any,                 arm64_sonoma:  "406250d272333d83e333a46cebf84c8034f040ad2e92f61d35a78c96d5318a9f"
    sha256 cellar: :any,                 arm64_ventura: "d0b52c1a4e60afbb399f0e738fbd5d8fca6b264c8880ee827c3a259704df3d93"
    sha256 cellar: :any,                 sonoma:        "cba6a81b8a29019eb6565cf7ce2e6a61a5bc6d0f3b8c0af43866336e9925fdb0"
    sha256 cellar: :any,                 ventura:       "df63b875bbb49ccac73ca8d79a61e8e0139f66303a9452bd73d8eb5eb05404e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cc8cd11eca881f6fff9fb90d2d822b861f5f20b455f2b17c0cbe5e77c8d4ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8edf4997d166ebc6a7f7dce1fb259500603ed7e2f54365c653f209b974da5005"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./cargo-crev")
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "crev", "config", "dir"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-crev", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
