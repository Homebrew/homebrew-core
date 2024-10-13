class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "96f1b1b4fd58e86f152b691202a15593815949dc9250fab9ab02f2346f5c2c52"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4e27b06c9b08465ccd35d9aac9e7af2aa67b851d1f38da06e05ef27eec0c887"
    sha256 cellar: :any,                 arm64_ventura:  "7d74520a15eff48b437e22e80850a0d279264e97bb2f99de5dc06c4a285cc3cb"
    sha256 cellar: :any,                 arm64_monterey: "bed2db59671ee1b0cd94a3358e3044fa49b0e9085336e64945d144cac16db505"
    sha256 cellar: :any,                 sonoma:         "1f1c281f21c9ca692c83c8b024dfd0558231a9e71d74a76cc9dff3d1046478d0"
    sha256 cellar: :any,                 ventura:        "d82fe1f18c13b4781d08259739358023aff5dedd548cbac6253d0abdf29a4620"
    sha256 cellar: :any,                 monterey:       "734ccab75d650d7c4414371ae7a5e0b974b25d8d99a3ce47f15b10e790c7cb21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d201496bdb5241906be8b746e76f212d694c4b3c67909899c9d51eed141cee8"
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
  depends_on "pkg-config" => :build
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
    system bin/"pcb2gcode", "--front=front.gbr",
                               "--outline=edge.gbr",
                               "--drill=drill.drl"
  end
end
