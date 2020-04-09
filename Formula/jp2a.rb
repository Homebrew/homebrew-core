class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://csl.name/jp2a/"
  # Do not change source from SourceForge to GitHub until this issue is resolved:
  # https://github.com/cslarsen/jp2a/issues/8
  # Currently, GitHub only has jp2a v1.0.7, which is broken as described above.
  # jp2a v1.0.6 is stable, but it is only available on SourceForge, not GitHub.
  url "https://downloads.sourceforge.net/project/jp2a/jp2a/1.0.6/jp2a-1.0.6.tar.gz"
  sha256 "0930ac8a9545c8a8a65dd30ff80b1ae0d3b603f2ef83b04226da0475c7ccce1c"
  revision 1
  version_scheme 1

  bottle do
    cellar :any
    sha256 "1ded015934d8e95c8fa21440973a9f57dfc8b607b46719e0698b61e5daee257b" => :catalina
    sha256 "97f05a0bb8f9ee5b075e21aff16503284592106cc87d384c1b85936128690345" => :mojave
    sha256 "36bd941b1b215c93b6934a085b9cf8fdaad2ba2ce47a8fbe096e53a144932201" => :high_sierra
    sha256 "a45231943df5bffc1589114b20b5b6c9745f909fd1e85db63da40e28bec02709" => :sierra
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
