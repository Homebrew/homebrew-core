class Freedink < Formula
  desc "Portable version of the Dink Smallwood game engine"
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftp.gnu.org/gnu/freedink/freedink-108.4.tar.gz"
  sha256 "82cfb2e019e78b6849395dc4750662b67087d14f406d004f6d9e39e96a0c8521"
  revision 2

  bottle do
    sha256 "d78130e6917a14d7a5e367bada96e919915695d68d7796709d5bb99fbbc593f9" => :high_sierra
    sha256 "c3d0467dd6eb6e2070e488d468cf3953257260401722dd28037a2b37326d604a" => :sierra
    sha256 "97ba862a21ab764b5cf1c3c5d40604c8b006c81a88839c20199966a494725c16" => :el_capitan
    sha256 "e4fa882a22081243a88ca1303f4aa7fe3843e4cc523fe973a5158b117e7d868e" => :yosemite
  end

  depends_on "check"
  depends_on "sdl2_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "gettext"
  depends_on "libzip"
  depends_on "fontconfig"
  depends_on "pkg-config" => :build

  resource "freedink-data" do
    url "https://ftp.gnu.org/gnu/freedink/freedink-data-1.08.20170409.tar.gz"
    sha256 "e1f1e23c7846bc74479610a65cc0169906e844c5193f0d83ba69accc54a3bdf5"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
    resource("freedink-data").stage do
      inreplace "Makefile", "xargs -0r", "xargs -0"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    assert_match "GNU FreeDink 108.4", shell_output("#{bin}/freedink -vwis")
    assert FileTest.exists?("#{share}/dink/dink/Dink.dat")
  end
end
