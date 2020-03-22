class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.16/libmwaw-0.3.16.tar.xz"
  sha256 "0c639edba5297bde5575193bf5b5f2f469956beaff5c0206d91ce9df6bde1868"

  bottle do
    cellar :any
    sha256 "c911649b2829547fe591010dcb908593de7b084c5ec88487cde17a654e84ee5f" => :catalina
    sha256 "7f226dc382e5a67fbeb2650e97503c53e95274c38b77d34b7e047737796eb42b" => :mojave
    sha256 "0e16cc626464cd858e158d2dca81d818ce2191ac694168f63f7252b74264e53b" => :high_sierra
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
