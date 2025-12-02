class Csha < Formula
  desc "Cryptographic Steganography and Hashing Library"
  homepage "https://gitlab.com/Malcolmston/project-final"
  url "https://gitlab.com/Malcolmston/project-final/-/archive/v1.1.9/project-final-v1.1.9.tar.gz"
  sha256 "21b70547c5283354e098292bb8166e93c1753f62dc8584c9ec59016ab64c894f"
  license "MIT"
  version "1.1.9"

  depends_on "pkg-config" => :build
  depends_on "opencv"
  depends_on "openssl@3"
  depends_on "libzip"

  def install
    # Set OpenSSL path for macOS
    ENV["OPENSSL_INC"] = Formula["openssl@3"].opt_include
    ENV["OPENSSL_LIB"] = Formula["openssl@3"].opt_lib

    # Build the project
    system "make", "all"

    # Install the binary
    bin.install "csha"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "Cryptographic Steganography and Hashing Library", shell_output("#{bin}/csha --help")
  end
end
