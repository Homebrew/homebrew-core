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
    sha256 cellar: :any,                 arm64_monterey: "3a30135d330f2b768291589843b24cde7344f54518160c264536c9cd23250f08"
    sha256 cellar: :any,                 arm64_big_sur:  "5fe649e5e343da32be7676e8790029d54baac8d774bbcd495c7967429e92e9a5"
    sha256 cellar: :any,                 monterey:       "046892c0f224f24e10a5778fd2b7de125f4bce367bfe05ce87129adac666f13f"
    sha256 cellar: :any,                 big_sur:        "5945a30d86c27fce4226a1147d63c062f94e802bedb60fef5f7667d30d002d50"
    sha256 cellar: :any,                 catalina:       "327f8abb39efba8d47c231eb679b70375a6a6b3ab6b0f53f9dc21c72a04a3ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f136449315a9e66724ef8a8b056151ec0579e7adf0433d50fadb3bac44634dc"
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
