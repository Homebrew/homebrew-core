class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://download.mono-project.com/sources/libgdiplus/libgdiplus-6.1.tar.gz"
  sha256 "97d5a83d6d6d8f96c27fb7626f4ae11d3b38bc88a1726b4466aeb91451f3255b"
  license "MIT"
  revision 1

  livecheck do
    url "https://download.mono-project.com/sources/libgdiplus/"
    regex(/href=.*?libgdiplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9b537ce5d2cfd7c632208114aeba4fa763659e6f7a08203f7bfc8ff809885ea1"
    sha256 cellar: :any,                 arm64_monterey: "b52734ab6bdc00e1b79d5e0ea316cfd3ca31761dbd7b8e08043dda470425166b"
    sha256 cellar: :any,                 arm64_big_sur:  "2911312b0811551362741646e5565673e98df0ef00c3ae72ab8ebf05458347fb"
    sha256 cellar: :any,                 ventura:        "7bc76c3a9f9e27b3c7d7d00ace9ed0a0156383ddd95411fb53b2dd1a627e48b8"
    sha256 cellar: :any,                 monterey:       "18090bbf1aad53b2ac5c787ef77c995c2cf7519adef6863116b304a224efdfc3"
    sha256 cellar: :any,                 big_sur:        "624eccbf7b63582b5b7f17b76d2b44c34f7bab08e9e3c7280957f603518a46bd"
    sha256 cellar: :any,                 catalina:       "4a034e8661fdb77377bdea527d3f74b6363a8f1691a5b7cf76419d1f7888b7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "736da321f47ed7ea4c676883b58b139d370bc1d3cee694140b9898d65b97bf37"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg-turbo"
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
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-tests",
                          "--without-x11"
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
