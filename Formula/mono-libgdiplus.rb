class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/6.0.5.tar.gz"
  sha256 "1fd034f4b636214cc24e94c563cd10b3f3444d9f0660927b60e63fd4131d97fa"

  bottle do
    cellar :any
    sha256 "2b2a77eb692e4383bcd370c67952a4da8000d79ac75c9bf9b4c02a5db291291a" => :catalina
    sha256 "aa006fa3746f4d6ecd7fa1b004adb5bf5061bcda97320d105eddf841f3c9087e" => :mojave
    sha256 "de806803fb54ffefa1fa627eadb5c7e627082ae3b4c8fb8554e0aa243cb412d3" => :high_sierra
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
