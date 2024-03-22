class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2024.3.20.tar.gz"
  sha256 "7f945a800ac716153947b7ca59b62fa559a886c77ac62c34fffdac426f1fc25f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "007a1a7d46186ceab76f51b5ab1e7dbc78c751c193a5b01605d0b17f1786a88e"
    sha256 cellar: :any,                 arm64_ventura:  "eaf1cdfbe5bf2a7621941e526489a9be95d5f2df1ceb1c5fa897c32650bd25d8"
    sha256 cellar: :any,                 arm64_monterey: "b8b80f83ccc64e26d468b8721f79c098edd601c4b3e2277dcba66aed333948a8"
    sha256 cellar: :any,                 sonoma:         "c9faa25889b441571d9541ba5b4050081d762c620e9d356e6898cbd4f8845c4e"
    sha256 cellar: :any,                 ventura:        "76a5823b52c96e5f616e10ff0cdcd78ac30fa791ef24a99b29731ef1c81ec8b4"
    sha256 cellar: :any,                 monterey:       "9ca3a71457bcc341e7bac374568e18c8946f23b860089caf757efdeb1fd33289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a7249d6db39173e657a29dfbe9530e02989c75772aa6e109698e81a0f02063d"
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
