class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.19/libmwaw-0.3.19.tar.xz"
  sha256 "b272e234eefc828c4bb8344af0f047a62e070f530e9e2fba11b04c8db8eda5af"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4ddbbeb71f424b659ab4f6f7d4c9d2bf94668c38c3f49a60ed9e26e7ce75a0e9"
    sha256 cellar: :any, big_sur:       "c370cf36d334e14e9f464878ec3f871b1957d9553e5873b338e9f5e9c36c9de8"
    sha256 cellar: :any, catalina:      "d012e7151f89ad3a2a05e9fc06eb916e7e3a306c36a983bdf39d6f5e66aaf38a"
    sha256 cellar: :any, mojave:        "7b092ef5379479401b41e4984ba99292977738dc7f6c87512f7f68a9b6c7bfc6"
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
