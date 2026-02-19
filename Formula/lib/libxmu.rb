class Libxmu < Formula
  desc "X.Org: X miscellaneous utility routines library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXmu-1.3.1.tar.xz"
  sha256 "81a99e94c4501e81c427cbaa4a11748b584933e94b7a156830c3621256857bc4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3119cf62a6b19cb301339f6611ad94df20c57f1d1f7cf508284f38baf9688bc"
    sha256 cellar: :any,                 arm64_sequoia: "bf7fa457cb2dc12f1ecf9adfb0e96187fc41f1d9654750c89c121e840df67d02"
    sha256 cellar: :any,                 arm64_sonoma:  "209c3e6cd9b134c9ccc2a59c27ead872c83a334c8d426fc3e845b363ab47f431"
    sha256 cellar: :any,                 sonoma:        "ae23ca0f5401937f9d17c94c13b0b34b1f4e514da51333974fd1da20dcd59cb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89de2ef3c3cd5817dff3f0967e7a737fe5a1d3fc26a2bc5b77c52da24f1a4ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9563085140d7172e3e0365803b529a62a211a55611907b58e6fdb3ce726ae19b"
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
