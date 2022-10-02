class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/v2.5.0.tar.gz"
  sha256 "96f1b1b4fd58e86f152b691202a15593815949dc9250fab9ab02f2346f5c2c52"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b05c1320d169fe31748c0a9fd173058f935ccf6872cd3425721aaf1e5f952e36"
    sha256 cellar: :any,                 arm64_big_sur:  "94d5932e1a4be6f56ea6f3b84decb4399ccdec66d5f0e2dd01f5583bd3cbe33d"
    sha256 cellar: :any,                 monterey:       "f2f0795787b32de91825ec1e7669cbfc9d530b7676f6d0bf9e9de0766c34ba6d"
    sha256 cellar: :any,                 big_sur:        "4a5397460b704b3ee51b2829cb9b340a2b67da3894e0df48a86d81aeb197a028"
    sha256 cellar: :any,                 catalina:       "25279d3a7f039f2b12412e897588d12891a1d03ef7cdbbd5fa61dfdd1af18748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01aac891f817b1b0f13b1f0a278a2bca50f70422058f480a9f3ec2dc5b888c4"
  end

  # Release 2.0.0 doesn't include an autoreconfed tarball
  # glibmm, gtkmm and librsvg are used only in unittests,
  # and are therefore not needed at runtime.
  depends_on "atkmm@2.28" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cairomm@1.14" => :build
  depends_on "glibmm@2.66" => :build
  depends_on "gtkmm" => :build
  depends_on "librsvg" => :build
  depends_on "libsigc++@2" => :build
  depends_on "libtool" => :build
  depends_on "pangomm@2.46" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gerbv"

  fails_with gcc: "5"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"front.gbr").write <<~EOS
      %FSLAX46Y46*%
      %MOMM*%
      G01*
      %ADD11R,2.032000X2.032000*%
      %ADD12O,2.032000X2.032000*%
      %ADD13C,0.250000*%
      D11*
      X127000000Y-63500000D03*
      D12*
      X127000000Y-66040000D03*
      D13*
      X124460000Y-66040000D01*
      X124460000Y-63500000D01*
      X127000000Y-63500000D01*
      M02*
    EOS
    (testpath/"edge.gbr").write <<~EOS
      %FSLAX46Y46*%
      %MOMM*%
      G01*
      %ADD11C,0.150000*%
      D11*
      X123190000Y-67310000D02*
      X128270000Y-67310000D01*
      X128270000Y-62230000D01*
      X123190000Y-62230000D01*
      X123190000Y-67310000D01*
      M02*
    EOS
    (testpath/"drill.drl").write <<~EOS
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
    (testpath/"millproject").write <<~EOS
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
  end
end
