class Libxxf86dga < Formula
  desc "X.Org: XFree86-DGA X extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXxf86dga-1.1.7.tar.xz"
  sha256 "b3be5b444d324cb6e0f4b5019a4972c99ea336ccb8ab7968eccefecd917ffde6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "907281ec6adea58481d3fc39bc197ecb0571d6f14e5c378841c208a46d912d9f"
    sha256 cellar: :any,                 arm64_sequoia: "d83d4cc53a55e42049fd43ece155dd14bd7b2b28d0b243bacfd1b29a75a45f9d"
    sha256 cellar: :any,                 arm64_sonoma:  "d196a76e83530cd6cb0762cca798f02d93a714a38ed61e050a177d15f4559c48"
    sha256 cellar: :any,                 sonoma:        "9c9adfc0a78c26f4f10cbcb5c028b34bc306e1da928595c5841fba4b45b7dd00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a793906bdb10702fa2e980947bdc1144322fb17e5222cf68b436a4a7ba24040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc06a4ad625912d3286ead1391d75246109b6cc76ee419685a394b6d1234c90"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"

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
      #include "X11/extensions/Xxf86dga.h"

      int main(int argc, char* argv[]) {
        XDGAEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
