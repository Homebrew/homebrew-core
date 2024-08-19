class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.19/pdf2djvu-0.9.19.tar.xz"
  sha256 "eb45a480131594079f7fe84df30e4a5d0686f7a8049dc7084eebe22acc37aa9a"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "16302ca2297a15cb537b4b2820f232dc067bb1db2afe32fb8b9e7acd2dbc72f1"
    sha256 arm64_ventura:  "1b89f7cc11c1ed0ad9893790ef19f53ac26da2d35b9cc7e65fb6aca6b08620c9"
    sha256 arm64_monterey: "50b7761da3c04a30f23e49483d009347968aa435f689cacdb51829a978a7bb6a"
    sha256 arm64_big_sur:  "7ab97261a347114c5682747d97619bd9bbb67a11f7f6f31183c7db874cff07e3"
    sha256 sonoma:         "1332a7cdfd88879204e4ac4b5c90ed8ba17d3290f6913f819415abbff00c42a8"
    sha256 ventura:        "2cfdba470ffefa30573ee653c830b797e32d0f885764f713b2f10062f0952275"
    sha256 monterey:       "9cbfd8910b823ca474078f727ef20f75eed9793a7a6f1f15ee772938935795dd"
    sha256 big_sur:        "45cf358f9a387f948a2ee380415a266db6714885dbfa5aad33438e176cb6a326"
    sha256 x86_64_linux:   "e4b86532ab3e73076c00a603625c2ee778d06f07c012d5362982404a2fe68ea2"
  end

  disable! date: "2024-02-01", because: :repo_archived

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
    system bin/"pdf2djvu", "-o", "test.djvu", "test.pdf"
    assert_predicate testpath/"test.djvu", :exist?
  end
end
