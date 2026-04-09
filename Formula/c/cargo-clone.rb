class CargoClone < Formula
  desc "Cargo subcommand to fetch the source code of a Rust crate"
  homepage "https://github.com/JanLikar/cargo-clone"
  url "https://github.com/JanLikar/cargo-clone/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "58e86bd3440fc103572f6d8ff20ff1f99cf1e676cddb29975f204a9cb03f5b14"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/JanLikar/cargo-clone.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c4b544b37b9b657f7f9e9b5f50c8abea0644c9fd5df85cfb10fef27737b3c9df"
    sha256 cellar: :any,                 arm64_sequoia: "2dcb5c906b3dd8b3b1d47c1a45c6c9ab40b6629de4990ede4c4b2c449e0f1a4a"
    sha256 cellar: :any,                 arm64_sonoma:  "7ef9e538a557821c7115fe2c2f086f6100ffad8926e8d5b152f536fba835cfa3"
    sha256 cellar: :any,                 sonoma:        "ac4cdb2157e0900e10ae7654549ea3e94563bd2fad05e73306044418ba16ee98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f91abbdb2155fc427a28a51d9fc630fcc3fadb4aa75f3f2ce28f56c802679a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43fe9543e5d0f96866f232b945c9524e4d516c41ef049f1aa39ffb6fe1ae8bfc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cargo-clone")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    require "utils/linkage"

    system "cargo", "clone", "clone", "git2"
    assert_path_exists "git2/Cargo.lock"

    dylibs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    dylibs << (Formula["curl"].opt_lib/shared_library("libcurl")) if OS.linux?

    dylibs.each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-clone", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
