class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/v2.5.0.tar.gz"
  sha256 "96f1b1b4fd58e86f152b691202a15593815949dc9250fab9ab02f2346f5c2c52"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83adb12d503b158b1437a8f2acf404de7884a2379fbbb4cc1ae1813ed9e6a6c5"
    sha256 cellar: :any,                 arm64_monterey: "c99e0090428ea8fa639cc81e16c15afcd8b735b9d562fc60198369111367a31d"
    sha256 cellar: :any,                 arm64_big_sur:  "9d3f240c3005a34a168920fa133b4b5412b136fce769760eabf5379fd91affbc"
    sha256 cellar: :any,                 ventura:        "e9b5ea8ab2529a05d2f748fccc374ab04c4d24a8aab632c5176f80fdf1bb6697"
    sha256 cellar: :any,                 monterey:       "4325f231ce7a6f35db794bcb8c9f1b3acb768c45a46cd8ab8e3e488bc62a325d"
    sha256 cellar: :any,                 big_sur:        "f05095ba713b3ca3b7834a5c9e3ec9d9059e8bc80f87c79f2e3254f9847a598f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fef49896da1220fe507c68ea63b675c0bd183f372c66b38257cfca449977c0c"
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
