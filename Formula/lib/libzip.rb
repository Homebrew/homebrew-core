class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.10.1.tar.xz", using: :homebrew_curl
  sha256 "dc3c8d5b4c8bbd09626864f6bcf93de701540f761d76b85d7c7d710f4bd90318"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "8ecf154f8c0bab71c0008c6f73eb8cd2df78cfa424d8bdcffc66dc95b3bf7c14"
    sha256 cellar: :any,                 arm64_ventura:  "cd7bda731a8b2e5d1a3cdf5be6b515718c56d55d16a5b45faa1a91daf9c0ca2b"
    sha256 cellar: :any,                 arm64_monterey: "a0d8bae54df1068c92ad894eddca0cd7465ecbaa3ef875c07c46bcea764bac71"
    sha256 cellar: :any,                 arm64_big_sur:  "6549fda9b8f6ac3904b55bc0b8c601ecf15773eb4c97c40091148559d69bfec1"
    sha256 cellar: :any,                 sonoma:         "f782643b254f58ddf3830272c0221f5d35db84ebd4f3d4ef19894ca0c91648ad"
    sha256 cellar: :any,                 ventura:        "4fca00c15a69f25064b40b12e37a6f552edd632f77e2947e076745b55aaeffd3"
    sha256 cellar: :any,                 monterey:       "5fbb0e2a2cd9b17a416d518d324d9eb3eac88626851bad41d9fb144ccebd8757"
    sha256 cellar: :any,                 big_sur:        "db6453b117d39f0fe310f30e0d92124c453dd1568edd5800fd886bdb2b35e9df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5c180236137518d040277c1310e4b7c34337a0d396053e9a2534861453f70bc"
  end

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "libtcod", because: "libtcod and libzip install a `zip.h` header"

  def install
    crypto_args = %w[
      -DENABLE_GNUTLS=OFF
      -DENABLE_MBEDTLS=OFF
    ]
    crypto_args << "-DENABLE_OPENSSL=OFF" if OS.mac? # Use CommonCrypto instead.
    system "cmake", ".", *std_cmake_args,
                         *crypto_args,
                         "-DBUILD_REGRESS=OFF",
                         "-DBUILD_EXAMPLES=OFF"
    system "make", "install"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match(/\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1))
  end
end
