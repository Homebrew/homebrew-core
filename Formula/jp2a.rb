class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://csl.name/jp2a/"
  url "https://github.com/cslarsen/jp2a/archive/v1.0.7.tar.gz"
  sha256 "e509d8bbf9434afde5c342568b21d11831a61d9942ca8cb1633d4295b7bc5059"

  bottle do
    cellar :any
    sha256 "1ded015934d8e95c8fa21440973a9f57dfc8b607b46719e0698b61e5daee257b" => :catalina
    sha256 "97f05a0bb8f9ee5b075e21aff16503284592106cc87d384c1b85936128690345" => :mojave
    sha256 "36bd941b1b215c93b6934a085b9cf8fdaad2ba2ce47a8fbe096e53a144932201" => :high_sierra
    sha256 "a45231943df5bffc1589114b20b5b6c9745f909fd1e85db63da40e28bec02709" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jpeg"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
