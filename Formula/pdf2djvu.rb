class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.19/pdf2djvu-0.9.19.tar.xz"
  sha256 "eb45a480131594079f7fe84df30e4a5d0686f7a8049dc7084eebe22acc37aa9a"
  license "GPL-2.0-only"
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "33b723c2bfdb9b47ff081bff8b45252b19b85ecab15a47eb8491e5a2a8078eeb"
    sha256 arm64_big_sur:  "c10abfb31260e88e496cd5d19a3432315a715e612b7374616082aa10b538dac8"
    sha256 monterey:       "4502308ab8f624835571461015fdafea2a826da3484709e4115216d0a29c7d9e"
    sha256 big_sur:        "04bcbe91fbbcead5d8cb4d1e2bf3a0cd6d11baf9e4e24417735df2637663561f"
    sha256 catalina:       "56bf827f6358b019e55d11a4088f57cf2601e06158f424bbec72436ea9fdadcd"
    sha256 x86_64_linux:   "7e3e073492d37b1cecc31a7040da683653bc8b92cf74bac8ae04ae609640714b"
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
