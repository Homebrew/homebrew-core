class Gpx < Formula
  desc "Gcode to x3g converter for 3D printers running Sailfish"
  homepage "https://github.com/markwal/GPX/blob/master/README.md"
  url "https://github.com/markwal/GPX/archive/2.5.2.tar.gz"
  sha256 "8b637a366a2863ca3a11b4c6a33d8ebc10806bf7de3e3ac90f2a3a57529ea864"
  head "https://github.com/markwal/GPX.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e51f98467745f27e906fa4d1152cb7fe7e73c2606872f2c9eba8d54fa250a32e" => :sierra
    sha256 "29621a041a78876e963bdd922c6ea5203f102dbbcd87038d3ade22eca6bafb29" => :el_capitan
    sha256 "451eab6ecaf8a42858ae0d71cfa141bc14fd3d0608285bc1a677422fcc8a662e" => :yosemite
    sha256 "d1fdd06431d4efa1043c364c34d1e2f1fd0d904aa58047829ec0beda4aa47340" => :mavericks
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
