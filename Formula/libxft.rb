class Libxft < Formula
  desc "X.Org: X FreeType library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXft-2.3.6.tar.xz"
  sha256 "60a6e7319fc938bbb8d098c9bcc86031cc2327b5d086d3335fc5c76323c03022"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "295a354aeac393fd30498499ff9541c4f237fbecf0259ddd611015c153fa505f"
    sha256 cellar: :any,                 arm64_big_sur:  "84ab0e299c671c1873e6e0555a9961e1d49c2b07c59d46257e46ec316fd337c5"
    sha256 cellar: :any,                 monterey:       "332f0d5ca3fd2009a2f8d2bfb39edc4a285acfc8607eee344b47181e6313dd9b"
    sha256 cellar: :any,                 big_sur:        "955d7574fb678d9a9b8b205846a716f6eb04af6471d11cc1fda2b2c294ec6969"
    sha256 cellar: :any,                 catalina:       "3d18dd85206abfdfd6c9300602c814590275412f7024da2267faad91836ce1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "705ee186ddb01dd7bccbcbb88cc54649dcdf191e39bc669e9715e1799ee72dd6"
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "libxrender"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
      #include "X11/Xft/Xft.h"

      int main(int argc, char* argv[]) {
        XftFont font;
        return 0;
      }
    EOS
    system ENV.cc, "-I#{Formula["freetype"].opt_include}/freetype2", "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
