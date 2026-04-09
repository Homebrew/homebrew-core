class Libxdamage < Formula
  desc "X.Org: X Damage Extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdamage-1.1.7.tar.xz"
  sha256 "127067f521d3ee467b97bcb145aeba1078e2454d448e8748eb984d5b397bde24"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd8c72e12bc4390bc1cf580b95a249ed14796f2cebe20d561d8990a25f1704a8"
    sha256 cellar: :any,                 arm64_sequoia: "fb9556f58e05054043c4e7850318a3e830d9eb18c765aba87c8c1fdbc5839f39"
    sha256 cellar: :any,                 arm64_sonoma:  "8eb76beb4891b0373f89273b539c22d5a1ad61c0a1c9870a50bfd5e38801d01e"
    sha256 cellar: :any,                 sonoma:        "aab270b6adedc70c4bee9306ee3f4fd14fd75c84a16f4a48c555a929e125f79e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4d714e5c7143dc61b08d35be29c81703ce118e845d9a659d0dfa19018a56441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e516c9736d4b32e5d4130a9221119e543dbff845b82b421621b9b89ed698fb0d"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxfixes"
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
      #include "X11/extensions/Xdamage.h"

      int main(int argc, char* argv[]) {
        XDamageNotifyEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
