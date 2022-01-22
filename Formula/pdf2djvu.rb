class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.18.2/pdf2djvu-0.9.18.2.tar.xz"
  sha256 "9ea03f21d841a336808d89d65015713c0785e7295a6559d77771dc795333a9fa"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "6c708493497551cc3ed6e0e58020c63610b0482cc5b5d84479ab36d0ce732cf0"
    sha256 arm64_big_sur:  "dce762ddeee20ff985f0e763c7e2617eb888bbe7d862ca91ace70e7002311739"
    sha256 monterey:       "9386ffc73cc1e3b5135a911c895a54c27c6e5649a50e73b90f952c5424c3b7b3"
    sha256 big_sur:        "e8ac9f7423372d5e34d8062bc4cfa6ac9bb60494ad09350953a160ad9734be39"
    sha256 catalina:       "218dfd7975fca8dbc68ca1b30be5baf2ef0eeacf672fe859769495b103e698eb"
    sha256 x86_64_linux:   "db4d722712ed255aa7c9d1f5d01d2196dd763ba037add533a735c635cede4d6b"
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
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), "test.pdf"
    system "#{bin}/pdf2djvu", "-o", "test.djvu", "test.pdf"
    assert_predicate testpath/"test.djvu", :exist?
  end
end
