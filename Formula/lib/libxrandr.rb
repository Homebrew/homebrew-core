class Libxrandr < Formula
  desc "X.Org: X Resize, Rotate and Reflection extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXrandr-1.5.5.tar.xz"
  sha256 "72b922c2e765434e9e9f0960148070bd4504b288263e2868a4ccce1b7cf2767a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36b7a9f0da5208be5b9b39138d0e0eba832e843d40c0f2e69f6d09b495741ddf"
    sha256 cellar: :any,                 arm64_sequoia: "c332c9afd47eff9b36b52ab2f318e020d140179bff663d8a224897b9782ace43"
    sha256 cellar: :any,                 arm64_sonoma:  "d687cfb76f86ee2577db8c75fb558fd615d55445bf003d18b0e1a9fe164baa78"
    sha256 cellar: :any,                 sonoma:        "03452b3eb7237aca7975992b9178b3c3dfeffd73693775ebf674cb95a3703392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2a61886e6c65894d681629c4117d61f4566fcc1955315008bc53f21a1b667b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bed6ab672a51a09e7b6da5d5d824dba33704ce745889d4eebf4917aa009a3b02"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxrender"
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/extensions/Xrandr.h"

      int main(int argc, char* argv[]) {
        XRRScreenSize size;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
