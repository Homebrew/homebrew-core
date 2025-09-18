class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.11.4.tar.xz"
  sha256 "8a247f57d1e3e6f6d11413b12a6f28a9d388de110adc0ec608d893180ed7097b"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "unable to get versions"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "498194ba402e9765b789588ba7b6c927e64df31547a582730b90c1ccc2bdba25"
    sha256 cellar: :any,                 arm64_sequoia: "01dbf417152e6679f7816936846b57170635558954c001964b594caee1c0dc33"
    sha256 cellar: :any,                 arm64_sonoma:  "9c9a3a40e3b80edf45e7e7b8e315d45e70262653d5f272c215f7e0a34357b32b"
    sha256 cellar: :any,                 arm64_ventura: "65696504b9278cc61b0b9dbdd20c4de31792b1a429316ce956d5a3473e3ac01e"
    sha256 cellar: :any,                 sonoma:        "99bf4ceaa405fcfa00f81e9afe430fcb9b6cb9485b35e807664629ed14ea8eff"
    sha256 cellar: :any,                 ventura:       "8feb1d8792de37063c569e8653d7ee1a0ddb4a030759ba99951a47b8eec9ca2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4e4593f93a74e7fc0ed1252c83b7ca85dd3d862d6cc0a883947cb4152e76b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bef3ccff46322f8b7af9b89c1849b54d5bb2b18f7a849988d113ed3cef52397"
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
    args = %w[
      -DENABLE_GNUTLS=OFF
      -DENABLE_MBEDTLS=OFF
      -DBUILD_REGRESS=OFF
      -DBUILD_EXAMPLES=OFF
    ]
    args << "-DENABLE_OPENSSL=OFF" if OS.mac? # Use CommonCrypto instead.

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match(/\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1))
  end
end
