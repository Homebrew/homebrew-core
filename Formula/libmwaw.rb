class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.21/libmwaw-0.3.21.tar.xz"
  sha256 "e8750123a78d61b943cef78b7736c8a7f20bb0a649aa112402124fba794fc21c"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e65d2c7d972499befc8ffddd4640604a0205ab0a87ce0184e3407269a133347b"
    sha256 cellar: :any,                 arm64_monterey: "6ffaa69023d1fb57fea42045e747e6df08336b1f00277fd1697c4480523533df"
    sha256 cellar: :any,                 arm64_big_sur:  "a4c331f83eb77f6bd74a828f984c376be9a916e7671946e299f7aeb347562d02"
    sha256 cellar: :any,                 ventura:        "fac6e29537af45eb097a6d18a263a0f4285661383cc8a82101d01c6b7ab287ae"
    sha256 cellar: :any,                 monterey:       "d20dccf2c767fceea530bc66a1c0c1631a8961245d627ef806b060781bc7f4b4"
    sha256 cellar: :any,                 big_sur:        "75d8edfd8ec17fdb6ca028ef30d183200539d8a47165fe0debfe27827eb4d081"
    sha256 cellar: :any,                 catalina:       "4966ab87822fed4a14a231116d3c4f84e17b40b1e632e353d0161976e4b151cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "646ae7bc535dc1b1ee19ce42ee1a438ea4adde05af0fb873048f41af857e108b"
  end

  depends_on "pkg-config" => :build
  depends_on "librevenge"

  fails_with gcc: "5"

  resource "homebrew-test_document" do
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
    testpath.install resource("homebrew-test_document")
    # Test ID on an actual office document
    assert_equal shell_output("#{bin}/mwawFile #{testpath}/NEWSSLID.DOC").chomp,
                 "#{testpath}/NEWSSLID.DOC:Microsoft Word 2.0[pc]"
    # Control case; non-document format should return an empty string
    assert_equal shell_output("#{bin}/mwawFile #{test_fixtures("test.mp3")}").chomp,
                 ""
  end
end
