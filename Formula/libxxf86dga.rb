class Libxxf86dga < Formula
  desc "X.Org: XFree86-DGA X extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXxf86dga-1.1.5.tar.bz2"
  sha256 "2b98bc5f506c6140d4eddd3990842d30f5dae733b64f198a504f07461bdb7203"
  license "MIT"

  bottle do
    cellar :any
    sha256 "f2df468f6664efce62f76994f334e5ddbcad8224fd7a38bf0379c4c9d9a4b0c4" => :big_sur
    sha256 "0201b2b16b731237e673e04fa85fbf60b51fc75c6e7918e1f0ae76e6560e8cbb" => :arm64_big_sur
    sha256 "15c9455a9f38b82ed8d6254ed5316426426fa5ae1451f3f0261adaf4c44f8c05" => :catalina
    sha256 "0c6b3b1caa96edeb68748295ecfd60001e50cffe3275dc156534d955bfc4951a" => :mojave
    sha256 "6d5cc78dafe39697dc39b8b061c74bff94046f9bf9819eded1c6575a5c4b9f4c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"

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
      #include "X11/extensions/Xxf86dga.h"

      int main(int argc, char* argv[]) {
        XDGAEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
