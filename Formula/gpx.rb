class Gpx < Formula
  desc "Gcode to x3g converter for 3D printers running Sailfish"
  homepage "https://github.com/markwal/GPX/blob/master/README.md"
  url "https://github.com/markwal/GPX/archive/2.4.3.tar.gz"
  sha256 "e2d67fd11b63b7ec30b122a4c4af6910305911dc3632ce18d213196be848993c"

  bottle do
    cellar :any_skip_relocation
    sha256 "daa0f72890ce52877941637f2ec33d8bf05f948c06babb214a8d778817a8fae9" => :el_capitan
    sha256 "f00fccb4ee486da781bb63c415167df55d50768e4989ae77ab0a296e5bdfc7f9" => :yosemite
    sha256 "8328513137d9c3328f0d447d2ea664eca67311c4cda37a9c3bcf4107d48728f8" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.gcode").write("G28 X Y Z")
    system "#{bin}/gpx", "test.gcode"
  end
end
