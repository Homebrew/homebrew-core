class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.11.4.tar.xz"
  sha256 "8a247f57d1e3e6f6d11413b12a6f28a9d388de110adc0ec608d893180ed7097b"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "unable to get versions"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08417964bf803b08c703fa297f87ff23998f73c6cfe0b327103d02c9a41582af"
    sha256 cellar: :any,                 arm64_sequoia: "6a65f5a729a460ee8988e05e9af08880215a008692dffede96e51694d0a8b428"
    sha256 cellar: :any,                 arm64_sonoma:  "41df5da85bc172a781efd6f32c46708f7a88f9b1faa82577cec64992f5254f5b"
    sha256 cellar: :any,                 sonoma:        "5b808617db89e546465d756a8d8e0ee7068806e7dc58ae06952eea528ebdce8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dd50da8a8ac50d993717bc5d59ed132a311a8d05ff65839ec038890b25bd518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6c30ff07c163ba9e53ccf30f1f21124a2fc2942adca5d34c8595840638f6ea2"
  end

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

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
