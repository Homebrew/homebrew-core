class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.10/gphoto2-2.5.10.tar.bz2"
  sha256 "66cc2f535d54b7e5a2164546a8955a58e23745e91e916757c0bf070699886690"

  bottle do
    cellar :any
    sha256 "7c73e23569faab407e1250a0a72d502bafc455e19dc7ee83f219e7a573e32788" => :sierra
    sha256 "b027c976521875f6cbe21186f1b61acb24e5dd21488cf5523275f0878db9789b" => :el_capitan
    sha256 "267da7eb4d18b6655464da8a70efc1b9a759e08460c31e0d45d3c85424068e91" => :yosemite
    sha256 "12e5c0d1d69f9385377a3e8522b73c6227f877789ab05a0527006cc5b872f2f9" => :mavericks
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
