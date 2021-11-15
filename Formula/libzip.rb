class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.8.0.tar.xz", using: :homebrew_curl
  sha256 "f0763bda24ba947e80430be787c4b068d8b6aa6027a26a19923f0acfa3dac97e"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e9e8c08f4a92b59d52825dd58414ef58b59561c02aa68a4081f59b8a426e78ab"
    sha256 cellar: :any,                 arm64_big_sur:  "c5842b42b9cbec01d11657ce19789f78b3f07e0350add80e894e57682a7ea3ba"
    sha256 cellar: :any,                 monterey:       "8ebe402be907386945c2479a5aab12d4ba08e39303837d7cf607ee226581ea91"
    sha256 cellar: :any,                 big_sur:        "6f3266d5fd14899d3c67dcc693365fda4531f17dc414039c66a8ad4f0becc819"
    sha256 cellar: :any,                 catalina:       "d708cee97ad3536abd1c4ab0fc4108477c04d944db47c9a427772bc23027d427"
    sha256 cellar: :any,                 mojave:         "5e54afd324365a37e9d6f4adec4ac6ea727012eb7b23931c94e2cf59b95b1bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "095cf6867438b44257ea4c38e19ad1f26423ad64f9a76c4139983039ee4607ab"
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
