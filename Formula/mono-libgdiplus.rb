class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://download.mono-project.com/sources/libgdiplus/libgdiplus-6.1.tar.gz"
  sha256 "97d5a83d6d6d8f96c27fb7626f4ae11d3b38bc88a1726b4466aeb91451f3255b"
  license "MIT"

  livecheck do
    url "https://download.mono-project.com/sources/libgdiplus/"
    regex(/href=.*?libgdiplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ee31a06b9b57bea4b687c7fdbf31ef039326675513c97d09514d9c57067bac8"
    sha256 cellar: :any,                 arm64_big_sur:  "1ffc07c204c2dfb3caad9695283676bb2793da4f95889d09fa2a976c2699720b"
    sha256 cellar: :any,                 monterey:       "90bbe857d612ced3c3eba4f1e303f47e7fd48bbc014dd77b7a588970cdb6402a"
    sha256 cellar: :any,                 big_sur:        "251d2f8b3f0aefe6678a1e34288cdcdc160410dc4b3b555d08cf58d01f9c37a0"
    sha256 cellar: :any,                 catalina:       "d72a67f877199f82b096a47a19b071414581fed3160f62942dcbe21804fb29b7"
    sha256 cellar: :any,                 mojave:         "c865c0d6aac91e8293d951a1c7d278bc8d64cba7babab1dc60f9fc198b6649fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3e7478ee77d32d5352fe5c82e100dd217ee709bcb1c831ebe8656c0b9aa5a89"
  end

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
  depends_on "pango"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
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
