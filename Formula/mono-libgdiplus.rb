class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "http://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/5.4.tar.gz"
  sha256 "ce31da0c6952c8fd160813dfa9bf4a9a871bfe7284e9e3abff9a8ee689acfe58"

  bottle do
    cellar :any
    sha256 "6e46cbc48b7de8501b9a926840f8a2cefb6f571eecd797a5fc6a63e6edf6a6a6" => :sierra
    sha256 "340ccb6b7480d14d7b4c86567d8eee88c7756e3981848b6c6381f2bc68fe7443" => :el_capitan
    sha256 "b3f99bf768ece5efd9f265969f2554083e3ceff6323e7ef8a390b7e6261abb0a" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
      int main() {
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgdiplus", "-o", "test"
  end
end
