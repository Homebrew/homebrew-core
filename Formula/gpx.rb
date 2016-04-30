class Gpx < Formula
  desc "Gcode to x3g converter for 3D printers running Sailfish"
  homepage "https://github.com/markwal/GPX/blob/master/README.md"
  url "https://github.com/markwal/GPX/archive/2.4.3.tar.gz"
  sha256 "e2d67fd11b63b7ec30b122a4c4af6910305911dc3632ce18d213196be848993c"

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
