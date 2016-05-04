class Gpx < Formula
  desc "Gcode to x3g converter for 3D printers running Sailfish"
  homepage "https://github.com/markwal/GPX/blob/master/README.md"
  url "https://github.com/markwal/GPX/archive/2.5.2.tar.gz"
  sha256 "8b637a366a2863ca3a11b4c6a33d8ebc10806bf7de3e3ac90f2a3a57529ea864"
  head "https://github.com/markwal/GPX.git"

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
