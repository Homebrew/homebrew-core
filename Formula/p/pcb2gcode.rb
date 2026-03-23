class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "a565905652963e5486a2e611e927550715fe59ea7a84b4bf8eceb03cbf72f574"
  license "GPL-3.0-or-later"
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79f6821c5f0c9b9aab253f4cdb3e36802e75d368cb16690aeccb84a0313f63fc"
    sha256 cellar: :any,                 arm64_sequoia: "9263e3befe02cb621424fec0e20362dcd51a034fe5384d3a3bbad6b2b2c6f292"
    sha256 cellar: :any,                 arm64_sonoma:  "140b0609ab0daea91c53a2d56fc8cf4a815e9ecd4a7136be1d830e2fa9b39c72"
    sha256 cellar: :any,                 sonoma:        "c73ca51c2d9130503f4548c47056a86ce4184ad10212f2e0142e33849612593a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de4cdfcd61ac455579ff0cec8631304122bb65ea68fb201442af778d5a66e3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b043174ffef39a89c0b672c263edd7de8feb4445cee66cad8eb54937d26338db"
  end

  depends_on "cairomm@1.14" => :build
  depends_on "cmake" => :build
  depends_on "glibmm@2.66" => :build
  depends_on "gtkmm" => :build
  depends_on "librsvg" => :build
  depends_on "libsigc++@2" => :build
  depends_on "pangomm@2.46" => :build
  depends_on "pkgconf" => :build
  depends_on "at-spi2-core"
  depends_on "boost"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gerbv"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "harfbuzz"
  depends_on "pango"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    system bin/"pcb2gcode", "--front=front.gbr",
                            "--outline=edge.gbr",
                            "--drill=drill.drl"
  end
end
