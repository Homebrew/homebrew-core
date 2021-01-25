class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.17/libmwaw-0.3.17.tar.xz"
  sha256 "8e1537eb1de1b4714f4bf0a20478f342c5d71a65bf99307a694b1e9e30bb911c"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "a070c58f39b1cec0e17145f3c48ab2f42c6d4cfb3b6d1f10d55d6f215b725c7f" => :big_sur
    sha256 "36820eedbe0a09fdb594c065effba926ef287dae4ffe1f141a2a55615c46d4e2" => :arm64_big_sur
    sha256 "807cff54beea1a3e68897da872ba18fcff59a6f617d46080beb95c769c97db2f" => :catalina
    sha256 "2c2d73c68fd3b5f0b3b1c028fda9900d9c75589e498b16bf275eafc3f414c8ab" => :mojave
    sha256 "7d29c815ecf0f72bc8623a1b13fc5d8e6786b54dd27609490ed75b720cdd5d90" => :high_sierra
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
