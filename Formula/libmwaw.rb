class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.15/libmwaw-0.3.15.tar.xz"
  sha256 "0440bb09f05e3419423d8dfa36ee847056ebfd837f9cbc091fdb5b057daab0b1"

  bottle do
    cellar :any
    sha256 "63063f14d3c766feb82ef52335aaecf5ebebafe5135721184e5a475cef9c7b4f" => :catalina
    sha256 "9b17fa0d1afca2803fed1412bcb20275552a73cf6a3ec6377d2070abc87310ee" => :mojave
    sha256 "a03479bf4c1becc688f76ce5c16519a6ccde95fc65da8d46c3e9cc6664b07fdb" => :high_sierra
    sha256 "cffc10a8c11055740f1baa7729df7d5744c018cd2deedd172cde0142989bb9b8" => :sierra
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
