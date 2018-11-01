class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 36

  bottle do
    cellar :any
    sha256 "7786efb798edcbc8410b097e1605706f8e5d628260e37e923579c27f2e91c828" => :mojave
    sha256 "03792920a4e0075217da7d7d827e46b9e43420a16a9ff4362827b072c7d720e3" => :high_sierra
    sha256 "42eee834f5cc8b49bbcf3b4d47e7c1881f406c7da82ab44354f5ace790f9e6c4" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxmac"
  depends_on :x11

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/diff-pdf", "-h"
  end
end
