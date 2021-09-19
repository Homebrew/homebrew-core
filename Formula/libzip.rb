class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.8.0.tar.xz"
  sha256 "f0763bda24ba947e80430be787c4b068d8b6aa6027a26a19923f0acfa3dac97e"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1634e10d0fbece803c007a5af63f3fbc9244ef4082640830039faeb7284a7ae1"
    sha256 cellar: :any,                 big_sur:       "f5b0d74305b2f249a8389bbee71ab51e446fcc824c950b2a954860d21e4d61b4"
    sha256 cellar: :any,                 catalina:      "cb8041e52eb6bdf4e06aa56823e4fe0ab8b008c25a84a8048b59e6c025cd2666"
    sha256 cellar: :any,                 mojave:        "5c0afe4c42e50e695446433cc8f0de47592f207281a01e30b4b39bd6b43096ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cff3dfdbd2565f16d6504215a03dd55bb9cd587051e89ce44bb1c326f7152fb"
  end

  depends_on "cmake" => :build

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "openssl"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  conflicts_with "libtcod", "minizip-ng",
    because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    system "cmake", ".", *std_cmake_args
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
