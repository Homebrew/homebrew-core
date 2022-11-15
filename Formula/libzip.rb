class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.9.2.tar.xz", using: :homebrew_curl
  sha256 "c93e9852b7b2dc931197831438fee5295976ee0ba24f8524a8907be5c2ba5937"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6da42edf5cc6f80780ace956a3d01cd213633ff4a06588d53f25c455efdf26a5"
    sha256 cellar: :any,                 arm64_monterey: "e27a1b53f6b09e0bb04071f66d878ef4594dbc3fde6e27a0b644d33a8ce34e0a"
    sha256 cellar: :any,                 arm64_big_sur:  "bd41180937e22a75118330708505944e31c613e303abdef8b247c5655fa5f82d"
    sha256 cellar: :any,                 ventura:        "d6c764255ed4b3350cace110c8a6e1f37fb512cf38c7dc1809b2ae66c0cc5a40"
    sha256 cellar: :any,                 monterey:       "9ebb3c03505035e35eb8b7f00fe6d9e25cce7a0ddd191334e5f090b37c5cb7ca"
    sha256 cellar: :any,                 big_sur:        "41b349a0653705d0d631e318d061faead49ecc26e6115d72f7f2b14273d0d924"
    sha256 cellar: :any,                 catalina:       "b2168c4e742cca12fc6c5ea740c3b5a64aada6a93a7cd9105743886c6ecae456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2e7f02d1e6de90dc42cea4ed2e198979bb00034455fadb4e1470f84124baf1c"
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
