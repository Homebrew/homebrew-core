class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2024.3.15.tar.gz"
  sha256 "2aa47779158e09625f1a012874e6200122727d595abb7e15e67a9f58535cb9d8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ccf9e0098ffe8df8fa5431055053143dfed36ddabb35414912f5ccd7f1ad79b5"
    sha256 cellar: :any,                 arm64_ventura:  "faeb53d41a253ca350330b46763788b82d303e5f85f225b89274065da6890f40"
    sha256 cellar: :any,                 arm64_monterey: "4f251996ea4187e2ad9a16ff095aa7a77f9dc5ba01364f0c235d060b9f76b8ac"
    sha256 cellar: :any,                 sonoma:         "b6e3720ac3195fa720f1337a48a4da2927751d677dabc038d2fdb3905d914921"
    sha256 cellar: :any,                 ventura:        "3e13eb40df8a6428a05c52d74208ebba4ef0f5f5a2d39a814e566736333ca5c5"
    sha256 cellar: :any,                 monterey:       "5fd1f83a74e16cd9aa8632951eb0696bec7f62e8b549b54981ab1f966a5a224e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48d3cc5f99c20603e20e153cbca1f24f8b01aa24429e831a02abb2a5ab23ef4d"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
