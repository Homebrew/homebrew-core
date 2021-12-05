class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.18.2/pdf2djvu-0.9.18.2.tar.xz"
  sha256 "9ea03f21d841a336808d89d65015713c0785e7295a6559d77771dc795333a9fa"
  license "GPL-2.0-only"
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "4012b760e63871b7f3c681ccea0e72e0b2fa74b6392f9497777bf2fdebaf33d2"
    sha256 arm64_big_sur:  "e88e8f395a0b1ab1ce7dc7b2a6d889bd3667be3c2baf92214645a2aca0de35d3"
    sha256 monterey:       "c78ccfe45c28a135c64dd8ada36e2588b52c15a51a977eb12d0f00502712a114"
    sha256 big_sur:        "fb2428fd41105fa3a66d7225869c3b0c0dc6446b893874eed02d956d349bcb7e"
    sha256 catalina:       "42f3d49aea624b4e86cdae4eedfd975640bb56812fc7f7fd7df10d369245f5d8"
    sha256 x86_64_linux:   "104808a2fcd37e99dfea5e919fda53595fc755a7ccad24bf72cf203a212a4282"
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
