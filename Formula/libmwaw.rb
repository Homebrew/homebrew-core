class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.11/libmwaw-0.3.11.tar.xz"
  sha256 "4b483a196bbe82bc0f7cb4cdf70ef1cedb91139bd2e037eabaed4a4d6ed2299a"

  bottle do
    cellar :any
    sha256 "75a60bcfcde26dab886a88ee7d67fd80f729971aea3b1a957a26ff866447349a" => :sierra
    sha256 "a25a61fe09ba938e8b6437f933d28e3baef920ce130113110521466250c8b3be" => :el_capitan
    sha256 "442749dbf4088d00406428942a6bd5cb5d5ee300b2070bc8a82a942cd9ffed8e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "librevenge"

  # Fixed upstream, will be in the next release.
  # https://sourceforge.net/p/libmwaw/libmwaw/ci/68b3b74569881248bfb6cbb4266177cc253b292f/
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libm/libmwaw/libmwaw_0.3.11-3.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libm/libmwaw/libmwaw_0.3.11-3.debian.tar.xz"
    sha256 "5377a0fb979c595b4b66076b57be980724d0afc9681a4e10c1566ac6cfc26886"
    apply "patches/CVE-2017-9433.diff"
  end

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
