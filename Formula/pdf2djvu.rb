class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.19/pdf2djvu-0.9.19.tar.xz"
  sha256 "eb45a480131594079f7fe84df30e4a5d0686f7a8049dc7084eebe22acc37aa9a"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "11574ea93107f5ff98e2d4a1f5fba58e1e477856bdea90d7791c3bf23796ea34"
    sha256 arm64_monterey: "ac4388068119f47f350f624452af744c35728b7300604423d00fe3c6133c7bb8"
    sha256 arm64_big_sur:  "987905a1b44426f34dd1278188c985d356ae13d952bad27ef2386d533724127d"
    sha256 ventura:        "a5ef6b50d214c421aefc1174d751f39df16e8ea7468c81609c99cb1744721191"
    sha256 monterey:       "d1dff2580f36051524eedf9172e28fa0ac585f53eb43cfa3e1fc710b0c3c39bc"
    sha256 big_sur:        "ed8df7c7e815a1ef6d07cddce7c0ede3dd14fdd0f2b10ff7b74599c4ba219890"
    sha256 catalina:       "307b93d7d052943b07010e71f8e726f36e2b3e41366e33d7a1943179e9968b2e"
    sha256 x86_64_linux:   "f4e9efb9a49baec7ea6085d1b3e4212fae1f531e85e35ed5acada7304a1d73a7"
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
