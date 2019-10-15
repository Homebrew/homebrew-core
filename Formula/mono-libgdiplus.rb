class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/6.0.4.tar.gz"
  sha256 "9a5e3f98018116f99361520348e9713cd05680c231d689a83d87acfaf237d3a8"

  bottle do
    cellar :any
    sha256 "f188b273e8486964db3cbbc9583112c6f6abffa37d996f0aab069dbb98c67682" => :catalina
    sha256 "b8ef1609c1fc1f76b488a4d98792bba7267549f7d861df0abb420b1f6f4d40d1" => :mojave
    sha256 "35cdac699b7bf1b7cf7a656007f1401e2c495bee8e7bead9a780be48c44ec5dc" => :high_sierra
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
