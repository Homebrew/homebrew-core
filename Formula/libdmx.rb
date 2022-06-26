class Libdmx < Formula
  desc "X.Org: X Window System DMX (Distributed Multihead X) extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libdmx-1.1.4.tar.bz2"
  sha256 "253f90005d134fa7a209fbcbc5a3024335367c930adf0f3203e754cf32747243"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6bf2f0af2c3b140e63c7c37f5d50e170bc46ada11ea7394244e6f788cce689d6"
    sha256 cellar: :any,                 arm64_big_sur:  "c9aae9326ce9a74e1082a3af3678b61694a90c8e360bcdf4b78c369be0ff95bf"
    sha256 cellar: :any,                 monterey:       "9b30c602541f5e61ec49e80d009d9bc237e9fcaebfd6084ccc494175a959af91"
    sha256 cellar: :any,                 big_sur:        "e5d9c7b5d007505a52338b9d901576fa407af1bc802ee392412b81e0266be641"
    sha256 cellar: :any,                 catalina:       "89fc7b694d6e0d2bd786f053bf9f8bb8aa2005f99319e6a75fad30dfcff7b831"
    sha256 cellar: :any,                 mojave:         "53a22f968698ff43bd3e483a77cc1c1a1b9bcc4ef3cbdfc6ffa5039d7e6af6b1"
    sha256 cellar: :any,                 high_sierra:    "d4b4e652d95db58f17afbf8d061cc161982b3726da03f403a05c14c8b99558a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c279c15fc371a0d20032999a293ac5d706ef91f94c9b786ae753baf9d319d0b"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/extensions/dmxext.h"

      int main(int argc, char* argv[]) {
        DMXScreenAttributes attributes;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
