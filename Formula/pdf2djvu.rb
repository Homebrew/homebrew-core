class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.18.1/pdf2djvu-0.9.18.1.tar.xz"
  sha256 "ab45d7c70ba837f01e6b5b5c18acf8af6200dad4bae8e47e4c2ca01fbf2fa930"
  license "GPL-2.0-only"
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "70f04cdd0ec4d96021281a2038d7b0681d0383db7c8746ec28a5cd57973c8c97"
    sha256 arm64_big_sur:  "ae36c7cbed57854173c39b024efa8d1f6aadc3d5089ad5bdea63205eefbf615f"
    sha256 monterey:       "117247d39fb8bd2c94326e5a2bd250eda403d3d35257ad183f5387a2132e3ee3"
    sha256 big_sur:        "dccec33cd3662985d4d6605632a78a24c6e73c6c80371e17d47471193e67e1ee"
    sha256 catalina:       "1e3d479f337cb61df898fe06bce62497cb0408b7fc924a7f463c506991aaaf0e"
    sha256 x86_64_linux:   "d45308c4972e6175119653dded5770009b152404ed3dd407ae5c47a1ae9b4714"
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
