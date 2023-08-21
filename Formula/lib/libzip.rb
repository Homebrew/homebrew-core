class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.10.0.tar.xz", using: :homebrew_curl
  sha256 "cd2a7ac9f1fb5bfa6218272d9929955dc7237515bba6e14b5ad0e1d1e2212b43"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7396ff8c885b5b409971c8f1327d8f5053d8d06e840e6bc6b993150c77cb663f"
    sha256 cellar: :any,                 arm64_monterey: "5bf073278ba871965559111f2f8be014817649c92059a46b3f9b82162d5163f9"
    sha256 cellar: :any,                 arm64_big_sur:  "43a494470436568645796a9387c1693c23123928bb87a85c404e5760456ab4be"
    sha256 cellar: :any,                 ventura:        "c7260f05af8676b4556a4f8257d04f0e88a49d6ea5a515abd4a4902bba8fef48"
    sha256 cellar: :any,                 monterey:       "c1d53223d07bea7473df733d36b446a80498b06c719e70403b619f969075235f"
    sha256 cellar: :any,                 big_sur:        "87f5c908912692fe28e548d51d96c8659d500bfb991784796ec149201a9a9e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eb7d9dff36b2fe8809015f1b1bf3f8cc6635a4b8db3b86ec6cdf7bc4e4858e2"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
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
