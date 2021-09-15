class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.20/libmwaw-0.3.20.tar.xz"
  sha256 "14c38b06214f277ccd1450e22e6e32648955018d7695896bc560165748c8cd21"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "19ee70bb69fcb13f204c761f6aab0aa65338920a0bb076f4b478e231432cc333"
    sha256 cellar: :any,                 big_sur:       "d01b3328f59d9bae2b955b955825af7521ed97713735d2143e687367cf3b00e3"
    sha256 cellar: :any,                 catalina:      "8f25e345c0fd4a4025d3bdcbcedb6325919d2c231de2f7a586440f3e95f18714"
    sha256 cellar: :any,                 mojave:        "eac21b3e50dbac8d892fdfd629ae111a105c12b7b16d6397f535e202ea30f367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c665a5811e38db40f415790baf26d066958ce0a99329db9ae837621b338ca434"
  end

  depends_on "pkg-config" => :build
  depends_on "librevenge"

  resource "test_document" do
    url "https://github.com/openpreserve/format-corpus/raw/825c8a5af012a93cf7aac408b0396e03a4575850/office-examples/Old%20Word%20file/NEWSSLID.DOC"
    sha256 "df0af8f2ae441f93eb6552ed2c6da0b1971a0d82995e224b7663b4e64e163d2b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_document")
    # Test ID on an actual office document
    assert_equal shell_output("#{bin}/mwawFile #{testpath}/NEWSSLID.DOC").chomp,
                 "#{testpath}/NEWSSLID.DOC:Microsoft Word 2.0[pc]"
    # Control case; non-document format should return an empty string
    assert_equal shell_output("#{bin}/mwawFile #{test_fixtures("test.mp3")}").chomp,
                 ""
  end
end
