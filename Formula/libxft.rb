class Libxft < Formula
  desc "X.Org: X FreeType library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXft-2.3.4.tar.bz2"
  sha256 "57dedaab20914002146bdae0cb0c769ba3f75214c4c91bd2613d6ef79fc9abdd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "df14d3422f930c8339a90745ea96ac4ed19dbd320e79bfea4870dae1d2b9bf2a"
    sha256 cellar: :any,                 arm64_big_sur:  "78a5e3d5795d9a95a012e1b9cbdc431373d1a2b9215dd4cc467ed8fe8833c8fd"
    sha256 cellar: :any,                 monterey:       "e5e3c477b818f83abb22998e773b850a63ac57011549c2d7cb7e3fd36099dfe6"
    sha256 cellar: :any,                 big_sur:        "1409b0b789f87502f146806ca110c91de010d4815a02d2a2b01a1fca8a9b34e1"
    sha256 cellar: :any,                 catalina:       "59ee89bf143385cf4d64b79b2b324874cbe8b5a1ecdaef2a9739fe6104bf240e"
    sha256 cellar: :any,                 mojave:         "b192514f22f8e6fe250afc95e471512622942dd02d3e58b7fbb0b085a281c667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32e3761cd7474d9f427959ce47db1b7449a1d210e51ad08d664a2f6b2092e229"
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
