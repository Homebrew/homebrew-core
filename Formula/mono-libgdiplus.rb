class MonoLibgdiplus < Formula
  desc "Provides a GDI+-compatible API on non-Windows operating systems"
  homepage "http://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/5.4.tar.gz"
  sha256 "ce31da0c6952c8fd160813dfa9bf4a9a871bfe7284e9e3abff9a8ee689acfe58"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libpng"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "pixman"
  depends_on "glib"
  depends_on "gettext"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libexif"
  depends_on "giflib"

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
    # Since there are no headers to install (due to the libs nature as part of mono)
    # The test just tries to include libgdiplus in the compile step, which should
    # fail if it is not present
    (testpath/"test.c").write <<-EOS.undent
      int main() {
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgdiplus", "-o", "test"
  end
end
