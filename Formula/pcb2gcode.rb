class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/v2.4.0.tar.gz"
  sha256 "5d4f06f7041fe14a108780bdb953aa520f7e556773a7b9fb8435e9b92fef614d"
  license "GPL-3.0-or-later"
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "4facc148f0dd1ed67cb098258f40210f13431239f36dd859a3605d8aba62a663"
    sha256 cellar: :any, arm64_big_sur:  "596ef4d44d9da58ce8ce77fc51605c9a1229a8b763e47f785baf202b0ba2a208"
    sha256 cellar: :any, monterey:       "20d4b84b6d91188a05455d39e7bf5a75314b641e11f41a860dc65ce318d78381"
    sha256 cellar: :any, big_sur:        "d08a9c3c499b9b9d510942cb8e7f6bae057eb29cadeab474ce0bbd13ae452d43"
    sha256 cellar: :any, catalina:       "5872fbb4710e05c4ad1795ea8cbb75fe26bc031cd00041156efc30f9fe632101"
    sha256 cellar: :any, mojave:         "73c321af8bd386af20ec60cf9e0c98600f12681b5bdd8bac70504457ebcc8bad"
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Apply upstream commit to fix build with GCC 11.  Remove with next release.
  patch do
    url "https://github.com/pcb2gcode/pcb2gcode/commit/01cd18a6d859ab1aac6c532c99be9109f083448d.patch?full_index=1"
    sha256 "b5b316b14e9b615ee9114261eb5d04a0b234823847a18bb5ab4d8e2af4210750"
  end

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
