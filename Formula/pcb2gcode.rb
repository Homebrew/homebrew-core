class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/releases/download/v1.2.3/pcb2gcode-1.2.3.tar.gz"
  sha256 "90fbd6c2c353609451e4284fcdcc395359ff582b13c053939f2da2825f081477"

  head do
    url "https://github.com/pcb2gcode/pcb2gcode.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"
  depends_on "gtkmm"
  depends_on "gerbv"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"front.gbr").write <<-EOS.undent
      %FSLAX46Y46*%
      %MOMM*%
      G01*
      %ADD10C,0.100000*%
      %ADD11R,2.032000X2.032000*%
      %ADD12O,2.032000X2.032000*%
      %ADD13C,0.250000*%
      D10*
      D11*
      X127000000Y-63500000D03*
      D12*
      X127000000Y-66040000D03*
      D13*
      X124460000Y-66040000D02*
      X127000000Y-66040000D01*
      X124460000Y-63500000D02*
      X124460000Y-66040000D01*
      X127000000Y-63500000D02*
      X124460000Y-63500000D01*
      M02*
    EOS
    (testpath/"edge.gbr").write <<-EOS.undent
      %FSLAX46Y46*%
      %MOMM*%
      G01*
      %ADD10C,0.100000*%
      %ADD11C,0.150000*%
      D10*
      D11*
      X123190000Y-67310000D02*
      X123190000Y-62230000D01*
      X128270000Y-67310000D02*
      X123190000Y-67310000D01*
      X128270000Y-62230000D02*
      X128270000Y-67310000D01*
      X123190000Y-62230000D02*
      X128270000Y-62230000D01*
      M02*
    EOS
    (testpath/"drill.drl").write <<-EOS.undent
      M48
      FMAT,2
      METRIC,TZ
      T1C1.016
      %
      G90
      G05
      M71
      T1
      X127.Y-63.5
      X127.Y-66.04
      T0
      M30
    EOS
    (testpath/"millproject").write <<-EOS.undent
      dpi=500
      metric=true
      zchange=10
      zsafe=5
      mill-feed=600
      mill-speed=10000
      offset=0.1
      zwork=-0.05
      drill-feed=1000
      drill-speed=10000
      zdrill=-2.5
      bridges=0.5
      bridgesnum=4
      cut-feed=600
      cut-infeed=10
      cut-speed=10000
      cutter-diameter=3
      fill-outline=true
      outline-width=0.15
      zbridges=-0.6
      zcut=-2.5
      al-front=true
      al-probefeed=100
      al-x=15
      al-y=15
      software=LinuxCNC
    EOS
    system "#{bin}/pcb2gcode", "--front=front.gbr",
                               "--outline=edge.gbr",
                               "--drill=drill.drl"
    IO.readlines("front.ngc")[-2..-1].any? { |line| line.include? "M2" } &&
      IO.readlines("outline.ngc")[-2..-1].any? { |line| line.include? "M2" } &&
      IO.readlines("drill.ngc")[-2..-1].any? { |line| line.include? "M2" }
  end
end
