class Libxcursor < Formula
  desc "X.Org: X Window System Cursor management library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXcursor-1.2.3.tar.xz"
  sha256 "fde9402dd4cfe79da71e2d96bb980afc5e6ff4f8a7d74c159e1966afb2b2c2c0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e25282b8f94e56dee8e9e3ddceccab288e744db1cbad429fb89afe34e273aebd"
    sha256 cellar: :any,                 arm64_sequoia: "8e5c2f6e0290a1308db48d7588e0ce6a831cb56011491470f3592e182db4f3d2"
    sha256 cellar: :any,                 arm64_sonoma:  "d030b6eaf5ac89a53962e3935e98ad22b8d269fe69941faf82ba9b93d8ccb0a7"
    sha256 cellar: :any,                 arm64_ventura: "68a9ded5d9e51bb9d9f1f9aaf8b67402c83c8fd11f28fdc557a0aa37ed28a129"
    sha256 cellar: :any,                 sonoma:        "9a063644b479ef0269bb01a8faa79eaab44cf159ffb4cd30d399beea2d5bf459"
    sha256 cellar: :any,                 ventura:       "c3dccfd8fffba3cb2dbee1135fb1ebaa601ae8d25fcdf1add36c13052cd62d6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2556c55f893b654072a287ea7ad7c5261beaf6cf3cd6b2c5feabc4c7b4a70d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e5f01e4940638fbcce577f05ac3bc57f87bf272959e286a323f6fe3c2fc86d"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxfixes"
  depends_on "libxrender"

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
      #include "X11/Xcursor/Xcursor.h"

      int main(int argc, char* argv[]) {
        XcursorFileHeader header;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
