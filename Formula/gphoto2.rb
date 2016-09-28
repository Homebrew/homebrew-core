class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.10/gphoto2-2.5.10.tar.bz2"
  sha256 "66cc2f535d54b7e5a2164546a8955a58e23745e91e916757c0bf070699886690"
  revision 1

  bottle do
    cellar :any
    sha256 "714d5f530c98f29159ba866abd70cb772bc8595aa1f99b47029ecf97d66691c3" => :sierra
    sha256 "85b358fcb55c0984314f2cdfec5e40b615e02f9d721a3c50d18bc967b41d06e2" => :el_capitan
    sha256 "7d520a495094d78aa0fc025206d7e66a92709075e18b74920f119b734b189293" => :yosemite
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
