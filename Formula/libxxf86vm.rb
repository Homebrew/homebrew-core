class Libxxf86vm < Formula
  desc "X.Org: XFree86-VidMode X extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXxf86vm-1.1.4.tar.bz2"
  sha256 "afee27f93c5f31c0ad582852c0fb36d50e4de7cd585fcf655e278a633d85cd57"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "52feffac5559d40bf041b8482fa3bd4b8de3ff5e36522e1be96fa2d799e75a18"
    sha256 cellar: :any,                 arm64_big_sur:  "c2f52435112da27491da0d3f8aae83ac4153bc17b2c8840d553c0556792eac52"
    sha256 cellar: :any,                 monterey:       "f446072b9274ef671bfabde806f5a60750644ff701c2fb5e60fca14c0ec75d13"
    sha256 cellar: :any,                 big_sur:        "3443b4465d3839bcee9bbf60a1028b0acfa45877f9b8bfd2654ca42ad1087d46"
    sha256 cellar: :any,                 catalina:       "0a4d6a9d0b98bd8b8cd2aa2025b6ee80a19ffca34744fed599ef0e754d9e810b"
    sha256 cellar: :any,                 mojave:         "c89b765023eb0b6820cbf776d6af714363dc6ebd1ea000e1e53a99fa79be4a0d"
    sha256 cellar: :any,                 high_sierra:    "37cf2b440d8d4e7cda6aa70d070cd45427cebc61781b6c1b3aec153bf82d638d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b356b86fb40bc67fab58f385afbf48d74996a776ee8d06b2c403df225bf66635"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
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
      #include "X11/extensions/xf86vmode.h"

      int main(int argc, char* argv[]) {
        XF86VidModeModeInfo mode;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
