class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.19/libmwaw-0.3.19.tar.xz"
  sha256 "b272e234eefc828c4bb8344af0f047a62e070f530e9e2fba11b04c8db8eda5af"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "21d172f695733abc5de6fbe72d6d07b5602094996af2679f7526f7ff72a01832"
    sha256 cellar: :any, big_sur:       "8ef538162e2384581e5fd08ee3a8c7c5f2c7266ecd76d391af41745fa89ca570"
    sha256 cellar: :any, catalina:      "09db91a432a35c88c04b6115716338c58699b4f4ceed3ba76db6f480ef5129ff"
    sha256 cellar: :any, mojave:        "62e5104b8b07b763fe2619701bd5379e31674ff11b46bfec419012428f6a43ca"
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
