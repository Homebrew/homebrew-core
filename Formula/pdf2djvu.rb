class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.19/pdf2djvu-0.9.19.tar.xz"
  sha256 "eb45a480131594079f7fe84df30e4a5d0686f7a8049dc7084eebe22acc37aa9a"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "f60bfb170d218b54a85117c30758cb1ae76d330b75d7132495fd96919f956465"
    sha256 arm64_monterey: "2feced1a60a2e914f09ea09f5dd013cc8c71f95c97fa377cf4c517fdcb279651"
    sha256 arm64_big_sur:  "b9506ca83126c838596b699970d006a789f4356122ae52288082d2b1aa870d3b"
    sha256 monterey:       "215e817755bcbf596a72a74e137d8c4092c45f20f644697cbef1ea83054d2401"
    sha256 big_sur:        "640ce4e6ae86b6ef7138e34e4b7ac1eb80e5dabab1576c2bcef7a516a32fbb0d"
    sha256 catalina:       "4dc8bb0f6bafdf5e3d5745e3d839928cb7945a6392c992099a49a850edb52de2"
    sha256 x86_64_linux:   "9551231aa0f5970a4e6707253724e538f4a97c5001226568fde62ee2a92e7e06"
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
