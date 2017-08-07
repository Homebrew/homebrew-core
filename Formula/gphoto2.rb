class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.14/gphoto2-2.5.14.tar.bz2"
  sha256 "9302d02fb472d4936988382b7277ccdc4edaf7ede56c490278912ffd0627699c"
  revision 1

  bottle do
    cellar :any
    sha256 "297aa13e741692abd0349a15c0d37d1cf3c8eb7dc4f9079dc3bc112d7bc3a26d" => :sierra
    sha256 "5abd1916cd153a91ba7ab30cd16d568132c6a910926e547cf7867ad9994f0cd7" => :el_capitan
    sha256 "58f17c0726cf8c17d220f1c03f0daab2586541b28fca81b4a7c880353bb0e2b3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
