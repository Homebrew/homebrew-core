class Libxmu < Formula
  desc "X.Org: X miscellaneous utility routines library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXmu-1.2.1.tar.xz"
  sha256 "fcb27793248a39e5fcc5b9c4aec40cc0734b3ca76aac3d7d1c264e7f7e14e8b2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0ee8170d775811319b3d3b43f657f9fab22e514c37800375ad0d52a051f3ed8e"
    sha256 cellar: :any,                 arm64_sequoia:  "b44c421e544a4a88eacaec0155108a9ce86a7d6aebf39e735d7d8656b2c7d768"
    sha256 cellar: :any,                 arm64_sonoma:   "cf78ddb72afdc7e39ad0aa9421ef8c6ef215a588311fff8d7924fb7dfe33d644"
    sha256 cellar: :any,                 arm64_ventura:  "06a9985ef9c93b62954e604491eda08c17ff0121c4db57e816ecdd0a89fc0b9a"
    sha256 cellar: :any,                 arm64_monterey: "e95b65aa281742d32783fe3e81a791f83740724c6a67b47196ef8c0c3ead9bc9"
    sha256 cellar: :any,                 sonoma:         "da9a3c49863a7674bd512cebf16c226be2b23fb576d7d40bee6912df3af5ebcf"
    sha256 cellar: :any,                 ventura:        "759a61777107ae7f9893f1a3f443be2f5605335cb63f64885b16ade1c1b9a22e"
    sha256 cellar: :any,                 monterey:       "1cf9194a1441427380e06054903045d3f247a93dc00943b7126db6badd715e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "002c127dd8dc9650c27a53829ad56073d729ea1487c6f0f1ac1e92b095010be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1da14c69af817c5faa1fc53dcf66a32a9319c75769562941f7e0ac20dbe2347b"
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
