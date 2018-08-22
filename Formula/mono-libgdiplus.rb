class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/5.6.tar.gz"
  sha256 "6a75e4a476695cd6a1475fd6b989423ecf73978fd757673669771d8a6e13f756"

  bottle do
    cellar :any
    sha256 "fab990ccafb532c88fe818f093df8ab9b9f9735bd91e87e0de1dbbaad7a90f7e" => :mojave
    sha256 "e025958c8b7c9e7ec1f699a9a32149f31e5ba66279d733948036f26e2f19699b" => :high_sierra
    sha256 "8cd50ca8eac2fae538ba0ecf66809838f4929c25e49b65c31c2c7e409cb560de" => :sierra
    sha256 "d099b8722d00774e64d1685cdb8506f03e3f026e05984cf4f0148359b5036693" => :el_capitan
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
