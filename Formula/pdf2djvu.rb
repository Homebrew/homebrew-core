class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.19/pdf2djvu-0.9.19.tar.xz"
  sha256 "eb45a480131594079f7fe84df30e4a5d0686f7a8049dc7084eebe22acc37aa9a"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "70b280582b9549d05a4dbc3500b48db63e65086ba2bdd9a580ef48b0c4da4d01"
    sha256 arm64_big_sur:  "0db4718e92f2e30baec71ae066f73d646c1b85084b7e0c41e9b9735f6a088261"
    sha256 monterey:       "d617ed4f9b869ee14686b27c65cd529fc222ff91bace4e25088121a7b30f6c12"
    sha256 big_sur:        "76dcea568c1d5cd21a3fd88a0200044ba4aac6f981465dfc53601d13b56b430b"
    sha256 catalina:       "94aa840e72765e2ba083816115237c32060ffc77cdcc79167592849de8a7318c"
    sha256 x86_64_linux:   "8a37d7d623f4237d8152a26a8c6dddf00308d6b092929cd368be5c186b8a44a5"
  end

  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  depends_on "exiv2"
  depends_on "gettext"
  depends_on "poppler"

  fails_with gcc: "5" # poppler compiles with GCC

  def install
    ENV.append "CXXFLAGS", "-std=gnu++17" # poppler uses std::optional
    ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR=1" if ENV.compiler == :clang
    system "./configure", "--prefix=#{prefix}"
    system "make", "djvulibre_bindir=#{Formula["djvulibre"].opt_bin}"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), "test.pdf"
    system "#{bin}/pdf2djvu", "-o", "test.djvu", "test.pdf"
    assert_predicate testpath/"test.djvu", :exist?
  end
end
