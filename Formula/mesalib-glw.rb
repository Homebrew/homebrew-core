class MesalibGlw < Formula
  desc "Open-source implementation of the OpenGL specification"
  homepage "https://www.mesa3d.org"
  url "https://mesa.freedesktop.org/archive/glw/glw-8.0.0.tar.bz2"
  sha256 "2da1d06e825f073dcbad264aec7b45c649100e5bcde688ac3035b34c8dbc8597"

  bottle do
    cellar :any
    sha256 "eed2ba469d6eb3188243850389500a436a5ecce39e946ff2e84c3fb85348f069" => :high_sierra
    sha256 "270fab4437a38d2d78d7789b2dd34b04e9c8a392975af41440aa14138bc31104" => :sierra
    sha256 "40caa5087e3b8b31b02c9ee7ec00f4eca3cdd4b35eec1fea0ce0ecd64a32689a" => :el_capitan
    sha256 "d700939e346f00e21a71e273895ff61d6984924d85cf41de461fb6674e326f8e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
