class CargoClone < Formula
  desc "Cargo subcommand to fetch the source code of a Rust crate"
  homepage "https://github.com/JanLikar/cargo-clone"
  url "https://github.com/JanLikar/cargo-clone/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "58e86bd3440fc103572f6d8ff20ff1f99cf1e676cddb29975f204a9cb03f5b14"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/JanLikar/cargo-clone.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "676a220d3866238b221ede7cb1f9c6438843f77bc42e72357100b7524cdc6356"
    sha256 cellar: :any,                 arm64_sequoia: "2ab584f9881aca397d0e8c2394281c9e372f9b77d8d99a7083b07207481d714a"
    sha256 cellar: :any,                 arm64_sonoma:  "7c899b4b1b143b9ec6973238b0f5133f6906dd945490751fe99bafa2acd1b496"
    sha256 cellar: :any,                 arm64_ventura: "59a6cb1abb30e784f1725baae6dec12ab0e70dfe55feb9a5102e6aa771d08e1b"
    sha256 cellar: :any,                 sonoma:        "63fba34768f4c2a2c0d4ccc9dad2aa04932d6245028fc0fc5c59b0e3f9289c8f"
    sha256 cellar: :any,                 ventura:       "72052760b11c391fc5ad31c4bd8d3b3e05c2ab29e56802d6972942d909e72f20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29cfd15121f91f34191bc8769ccc3dd927f153b6112d529557be54095909db05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9fbc19a7007107a7c769ba8d8bc06dbe960fc7e38d9ac2096b99f8cf8e58489"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
