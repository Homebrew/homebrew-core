class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/6.0.5.tar.gz"
  sha256 "1fd034f4b636214cc24e94c563cd10b3f3444d9f0660927b60e63fd4131d97fa"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1ffc07c204c2dfb3caad9695283676bb2793da4f95889d09fa2a976c2699720b"
    sha256 cellar: :any,                 big_sur:       "251d2f8b3f0aefe6678a1e34288cdcdc160410dc4b3b555d08cf58d01f9c37a0"
    sha256 cellar: :any,                 catalina:      "d72a67f877199f82b096a47a19b071414581fed3160f62942dcbe21804fb29b7"
    sha256 cellar: :any,                 mojave:        "c865c0d6aac91e8293d951a1c7d278bc8d64cba7babab1dc60f9fc198b6649fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e7478ee77d32d5352fe5c82e100dd217ee709bcb1c831ebe8656c0b9aa5a89"
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
  depends_on "pango"
  depends_on "pixman"

  # Remove at next version bump.
  # Upstream PR: https://github.com/mono/libgdiplus/pull/605.
  # Without this patch, it requires pango 1.43 or lower (current available version is 1.48).
  patch do
    url "https://github.com/mono/libgdiplus/commit/8f42e17e92c562cc243844b8a004cd03144b1384.patch?full_index=1"
    sha256 "b38823891ea201588c1edf29f931a0d353a155d7fac36f114482bbe608c5a1c9"
  end

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
