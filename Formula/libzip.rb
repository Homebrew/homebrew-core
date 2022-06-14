class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.9.0.tar.xz", using: :homebrew_curl
  sha256 "a17240ee88f0705a9067bb0087fde1cee73948b3cf6c3978a21a58fdb73b76a2"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ad8e34d264443a074264df809ca70dd2bfe55a7cd511fd658e8bba682b7e978b"
    sha256 cellar: :any,                 arm64_big_sur:  "db0326c4687c99aa5369b77bd7c25eda7cb2e69b4c91022c58f81e5aeca0ced7"
    sha256 cellar: :any,                 monterey:       "951eaaba841b56b2ff138cf936a7f0f9778b5d74d9f4966721c8e514d3d1135d"
    sha256 cellar: :any,                 big_sur:        "69f093d0c352f9b0299a61b23bed9a7d9a9a3398fbb950f103e83a1436b3d78b"
    sha256 cellar: :any,                 catalina:       "6cefcc1acf0ac196e09fa3ee4c7fb01d71edf9e0ddbd9602f6990a4d4c8fcea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce199d2779e986e7d8e5aa2d2d4e72200e32ed6e0d73971dfc376d5f67d5c800"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  conflicts_with "libtcod", "minizip-ng",
    because: "libtcod, libzip and minizip-ng install a `zip.h` header"

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
