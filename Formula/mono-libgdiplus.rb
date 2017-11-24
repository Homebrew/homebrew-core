class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "http://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/5.6.tar.gz"
  sha256 "6a75e4a476695cd6a1475fd6b989423ecf73978fd757673669771d8a6e13f756"

  bottle do
    cellar :any
    sha256 "2394e05ff330a320c3e4a5be9f75ecf9b99d7ce8335e32946ae918356ac7a64d" => :high_sierra
    sha256 "7de54b1030142de0dbb536fc596fd076fc632477a8aad56a8d9a90bfd353af07" => :sierra
    sha256 "0949dcf922e2d07e35d76019257e0b31e719cf9d6876f05fec1eeb45d2b30849" => :el_capitan
    sha256 "82d0521870289c51cc0f1b8f7707f0e22d15622fb538bb4895b079e5af63638b" => :yosemite
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
