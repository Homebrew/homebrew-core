class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.19/pdf2djvu-0.9.19.tar.xz"
  sha256 "eb45a480131594079f7fe84df30e4a5d0686f7a8049dc7084eebe22acc37aa9a"
  license "GPL-2.0-only"
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "726660db7fb78485e9c9bb257b7d36b74a2697d028e665135488a9df2adcda53"
    sha256 arm64_big_sur:  "cffa66d26e78af00e14559f7056902927f686cee5a8f779fca080cda76fe441e"
    sha256 monterey:       "26badfd16398ca9e62d6b2f3aec0c1408b081d827cb1cbe93def5912fa5a2390"
    sha256 big_sur:        "c2814243e1afc862ab67963545813093832d88ae2af98df079c385cd2a30087d"
    sha256 catalina:       "dbf8067f203a907be60500a82af23e6a6770657b9bf1de12f1ff010225cba2f3"
    sha256 x86_64_linux:   "fd4c9e079e87fd84841d8ed98f036bda71aaeff21fa284eadf86fd330817caf9"
  end

  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  depends_on "exiv2"
  depends_on "gettext"
  depends_on "poppler"

  on_linux do
    depends_on "gcc"
  end

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
