class Mhash < Formula
  desc "Uniform interface to a large number of hash algorithms"
  homepage "https://mhash.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz"
  sha256 "3dcad09a63b6f1f634e64168dd398e9feb9925560f9b671ce52283a79604d13e"

  livecheck do
    url :stable
    regex(%r{url=.*?/mhash[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f4f6e0a5a12cde078c2397874e309565d84a5599cbad4d5772ee13131deba98e"
    sha256 cellar: :any,                 arm64_big_sur:  "4f7da0cd859fc828d90946d6c6b80d80a60a85ffe4f82f9dd299ff1b8ba1bb54"
    sha256 cellar: :any,                 monterey:       "a8dbb4a5d3b15a10104683fdea162c85714cc0f4ef6f313c06aab7ddd0d1d42a"
    sha256 cellar: :any,                 big_sur:        "4553e5e48c17e06ad3290dd6ceabb6c9fee21be5b70194c03dd03d7bda873209"
    sha256 cellar: :any,                 catalina:       "d7d0a96656fbae5b279223d120bfe456c775a0c751090049bcf3ffffb2231761"
    sha256 cellar: :any,                 mojave:         "b4ee65a9ee33f5e19e085c477ec1634e2aa1626331eb2465484713759b264163"
    sha256 cellar: :any,                 high_sierra:    "82f39af8037f070fafcad0280b151dc58e1b5b8c3ea1fb75f4ee372256d3ad2b"
    sha256 cellar: :any,                 sierra:         "f630165dd7f7a0f8e5b710e0e0af5ebca6ca0edc98cd46a01b617a3e16bff7ea"
    sha256 cellar: :any,                 el_capitan:     "8817cea2b724d7ea00fd1efb348aa8bdb5d93ca155cb9ccf8eb316f76b42941b"
    sha256 cellar: :any,                 yosemite:       "fb03873f042a16fd2db5ae2a7eb62e970927b75a9dff92decbb3fd035a2bd41f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32a5e81c29e8407754448e5aa7f1f8ea2328bc5ce266ab5f3b350e3174373900"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Regenerate the very old configure script that isn't suitable for modern macOS.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "mhash.h"
      int main() {
        MHASH td;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmhash", "-o", "test"
    system "./test"
  end
end
