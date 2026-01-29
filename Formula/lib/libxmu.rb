class Libxmu < Formula
  desc "X.Org: X miscellaneous utility routines library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXmu-1.3.1.tar.xz"
  sha256 "81a99e94c4501e81c427cbaa4a11748b584933e94b7a156830c3621256857bc4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab4c600bd72d40fa49afd32e6133163ad650df61074620bd92f2a99ade510314"
    sha256 cellar: :any,                 arm64_sequoia: "e59d51c83501b661fecfaf6a5e66faba5f8d0adaece6a293738c1e67112c712f"
    sha256 cellar: :any,                 arm64_sonoma:  "103588f768f0ae6cdadba8dad3a3fadc2ff6e3ef91e243e6e072f3030c2bf8c0"
    sha256 cellar: :any,                 sonoma:        "fb06bfa8c6dca90cf5eee7dc1b2de38e88ceb3ef9b9cc949b2b56fb79227a529"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4424f0ba2eb7452caa1f49dd0ac7d8c1b8ba41d33e12911f08ec75571637f5fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c43704f643250f8ca01798410167abeee5890051b1133c34d1053054611d8ef"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxt"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/Xmu/Xmu.h"

      int main(int argc, char* argv[]) {
        XmuArea area;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lXmu"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
