class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "887f3af119b1501be27a35b293087ce2a1c94ae05e00c6052bc91ae86db680b2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff9ac69a8edba6c4f1889f9c1879ecb54e432650b60ea8f6244f11fab5d27ff9"
    sha256 cellar: :any,                 arm64_sonoma:  "9e5bf284d13f482bee99dc71d17f4b90268bf1fde45a5e629408b4bd23d1b9b3"
    sha256 cellar: :any,                 arm64_ventura: "6a2152dbf040856d61a56850c25b8b942f6646833d27f53e0f2ed79be10f98a4"
    sha256 cellar: :any,                 sonoma:        "98ae326caf8e5285e61eb450718b62229f889d8f0ecea8e752486c8c476a772f"
    sha256 cellar: :any,                 ventura:       "09317218c42fd0d44152209fe2740d4a0d182e7408a6fc88a9f789e9fea0698a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e4c0f32c0a1aba3f6e927fdaa089d871987c5f6346e57cae13b55ae6b5bfe4d"
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "crev", "config", "dir"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-crev", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
