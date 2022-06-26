class Libmwaw < Formula
  desc "Library for converting legacy Mac document formats"
  homepage "https://sourceforge.net/p/libmwaw/wiki/Home/"
  url "https://downloads.sourceforge.net/project/libmwaw/libmwaw/libmwaw-0.3.21/libmwaw-0.3.21.tar.xz"
  sha256 "e8750123a78d61b943cef78b7736c8a7f20bb0a649aa112402124fba794fc21c"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8e8b9c289bfacec49f6698fb9b3024c92b86e89d6712069112faf4e777616b45"
    sha256 cellar: :any,                 arm64_big_sur:  "6079d619891c7379f984bb8e9c50f090183ee97fc291bbbcf354b7e73cf334ab"
    sha256 cellar: :any,                 monterey:       "ec17c3a3d8014901bb3dedca4c2d532c8f343c28f39130d49ac29c88b5dd47e6"
    sha256 cellar: :any,                 big_sur:        "81fab7be2a6f5352ab9757cfa5a93827debc0a0469897a4b28922ca31a53fba5"
    sha256 cellar: :any,                 catalina:       "98c7ef307cac9580e285a6c871b392cc7e67036906ff8565d55bbb5c6498850a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8853b2f34f3f561be4cef972c911697afd90e1404207f73f782cb113cb0e4ec9"
  end

  depends_on "pkg-config" => :build
  depends_on "librevenge"

  on_linux do
    depends_on "gcc"
  end

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
