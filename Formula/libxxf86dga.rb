class Libxxf86dga < Formula
  desc "X.Org: XFree86-DGA X extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXxf86dga-1.1.5.tar.bz2"
  sha256 "2b98bc5f506c6140d4eddd3990842d30f5dae733b64f198a504f07461bdb7203"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1194aa1d850a1e3d32425e00b01d3713d0e5aa634e5cb0ada31d982f0b65411e"
    sha256 cellar: :any,                 arm64_big_sur:  "0201b2b16b731237e673e04fa85fbf60b51fc75c6e7918e1f0ae76e6560e8cbb"
    sha256 cellar: :any,                 monterey:       "1639ba24f0392cb6636909d5550b154b0ece475ba426c33a500d71e1b5851cdb"
    sha256 cellar: :any,                 big_sur:        "f2df468f6664efce62f76994f334e5ddbcad8224fd7a38bf0379c4c9d9a4b0c4"
    sha256 cellar: :any,                 catalina:       "15c9455a9f38b82ed8d6254ed5316426426fa5ae1451f3f0261adaf4c44f8c05"
    sha256 cellar: :any,                 mojave:         "0c6b3b1caa96edeb68748295ecfd60001e50cffe3275dc156534d955bfc4951a"
    sha256 cellar: :any,                 high_sierra:    "6d5cc78dafe39697dc39b8b061c74bff94046f9bf9819eded1c6575a5c4b9f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90a0ed3aaca33cb9473fcd74f0a7eaf4fb2301ada2d1d31f865941f92c81589"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
