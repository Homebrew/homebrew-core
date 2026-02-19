class Libxfont < Formula
  desc "X.Org: Core of the legacy X11 font system"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfont-1.5.4.tar.bz2"
  sha256 "1a7f7490774c87f2052d146d1e0e64518d32e6848184a18654e8d0bb57883242"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e67ab6488122aaf72e62534722893856d438840f8c2be91950e922f6b2aa509c"
    sha256 cellar: :any,                 arm64_sequoia: "4e2981c04822c7efdc9cd2b29625f52f5406db53613ef8474c57e9f32ff79b65"
    sha256 cellar: :any,                 arm64_sonoma:  "d4ceed82b1c206c84407c66028ddd6ea0b874d8f5c77290871fb93aba5c0a2d5"
    sha256 cellar: :any,                 sonoma:        "913aa317afeac3ee52224b4bab70b27047776573aaad9ae5d9f8a585731519e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc80dc4b8c1597f1848ed8694f4f85073a7d983fd8750291424f04a19f75379c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd3c5bf1aee1eda7aa8a4f56b8e1e25a91d138a220825e9f59e4f11f8f11ee1c"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xtrans" => :build
  depends_on "freetype"
  depends_on "libfontenc"
  depends_on "xorgproto"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-devel-docs=no
      --with-freetype-config=#{Formula["freetype"].opt_bin}/freetype-config
      --with-bzip2
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/fonts/fntfilst.h"
      #include "X11/fonts/bitmap.h"

      int main(int argc, char* argv[]) {
        BitmapExtraRec rec;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
