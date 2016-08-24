class MonoLibgdiplus < Formula
  desc "C-based implementation of GDI+ API http://www.mono-project.com/"
  homepage "http://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/4.2.tar.gz"
  sha256 "98f8a8e58ed22e136c4ac6eaafbc860757f5a97901ecc0ea357e2b6e4cfa2be5"

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

  # This patch removes the X11 dependency, from an open libgdiplus PR
  patch do
    url "https://github.com/mono/libgdiplus/pull/35.patch"
    sha256 "65d7e63e00645a40449df042244e647bd4d2c66eb15312aca42dff8413b639f9"
  end

  def install
    system "./autogen.sh", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--disable-tests",
                           "--prefix=#{prefix}"
    system "make"
    # Tests aren't installed, nor are headers due to the nature of
    # the lib - run a test here as part of the install
    cd "tests" do
      system "make", "testbits"
      system "./testbits"
    end
    system "make", "install"
  end

  test do
    # Since there are no headers to install (due to the libs nature as part of mono)
    # The test just trys to include libgdiplus in the compile step, which should
    # fail if it is not present
    (testpath/"test.c").write <<-EOS.undent
      int main() {
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgdiplus", "-o", "test"
  end
end
