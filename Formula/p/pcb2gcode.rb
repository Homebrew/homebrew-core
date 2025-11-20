class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "96f1b1b4fd58e86f152b691202a15593815949dc9250fab9ab02f2346f5c2c52"
  license "GPL-3.0-or-later"
  revision 10
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c7bb5342f773b41b6b485728e03aac465b7af391595656ca98a534092417cca"
    sha256 cellar: :any,                 arm64_sequoia: "ff258b7d916b2586d2c1275f340e583352c050ce6e11f5fe88769fa1afa9eb18"
    sha256 cellar: :any,                 arm64_sonoma:  "f34119207d88d392cd9bc22d9e2f8a60b75dac989cfd4eacd3f65c54b6796752"
    sha256 cellar: :any,                 arm64_ventura: "b01464e9d453255290840876db3899984cceff1a5c6c5046bd6bdae5d79d563e"
    sha256 cellar: :any,                 sonoma:        "0cd3f0c8556a36e6bfb7238ecb698108c85c97396e4a6b1966752868c6d3cbe0"
    sha256 cellar: :any,                 ventura:       "1bee47236c3414536c8c77badab1057fb363eb35cb76cde433aea647a0bf53f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06977900652f188f45575688519d4fb379b8d1c01d778e7f5676d79afbac604b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f0101b39171e4e96a6f5db51c8316b78251cd5c78867819d376c8845c5e0ada"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cairomm@1.14" => :build
  depends_on "glibmm@2.66" => :build
  depends_on "gtkmm" => :build
  depends_on "librsvg" => :build
  depends_on "libsigc++@2" => :build
  depends_on "libtool" => :build
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
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
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
    system bin/"pcb2gcode", "--front=front.gbr",
                            "--outline=edge.gbr",
                            "--drill=drill.drl"
  end
end
