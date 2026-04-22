class Libxpm < Formula
  desc "X.Org: X Pixmap (XPM) image file format library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXpm-3.5.19.tar.gz"
  sha256 "f241f705c607fba1a53338f7e1c12005d6da326b5cb55a11a10847781b4578c0"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fef03ab80e768bc0fc5c567e800c95bca21157340e0e0d297537c8d595215e85"
    sha256 cellar: :any,                 arm64_sequoia: "79818bdb6efbfd188b9511251f22d217b49b2fb7970ab09810386da0f5d13287"
    sha256 cellar: :any,                 arm64_sonoma:  "e090a33a97bb1e17d100c1ea7bc335e18a5e265d26712e3fe572f8c9ab17c47a"
    sha256 cellar: :any,                 sonoma:        "252204dc54592339724faab52d4589ce62610b17f9a2b7a5d3d2c890f52af4a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8af9cf8b188aae0d4730b2a6aea7afaf282867299d4a4b62281bdf1d47eae5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43b6a4aabe0711b533e2c6cf27db7bb0568817c54fb5ecf91d1e6dd6b62abcb3"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "libx11"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-open-zfile
      --disable-silent-rules
      --disable-stat-zfile
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/xpm.h"

      int main(int argc, char* argv[]) {
        XpmColor color;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
