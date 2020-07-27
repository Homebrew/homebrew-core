class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/6.0.5.tar.gz"
  sha256 "1fd034f4b636214cc24e94c563cd10b3f3444d9f0660927b60e63fd4131d97fa"
  license "MIT"

  bottle do
    cellar :any
    sha256 "14bb84ad43cf17791299bcc76e3d410f7c7176f169f2cfcfcbc65bda3d8abbf8" => :catalina
    sha256 "1e7e0566530f6cbefd2e7a57d1fdcaead797d36f07a1688e2b7a8460a0ac96f7" => :mojave
    sha256 "3c57fe1805bb35d6bc87b1c96e99e523357226a1089b4892efc520941dbfc245" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pixman"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-x11",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make"
    cd "tests" do
      system "make", "testbits"
      system "./testbits"
    end
    system "make", "install"
  end

  test do
    # Since no headers are installed, we just test that we can link with
    # libgdiplus
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgdiplus", "-o", "test"
  end
end
