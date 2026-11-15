class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "1dc10343a16d291c058b3d79e6ded25f13a99584b1b0d572808cd33216358cc1"
  license "GPL-3.0-or-later"
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d7400a9fb093342400b9530044c0fa7fd5980c4be61525285e9f4a68346e9389"
    sha256 cellar: :any, arm64_tahoe:       "9c6cd81020472d56114ff718e2f892c746efbb4b2569d1f42aca9467c3438862"
    sha256 cellar: :any, arm64_sequoia:     "8d1608cd5be02000a701da77f6e5c527d0983c9942bd9468a845ba223fe31baf"
    sha256 cellar: :any, arm64_linux:       "fcc5767aa9c7dbf1c99734af350dac94da76a4c31e52772105c646bae0fba231"
    sha256 cellar: :any, x86_64_linux:      "a511d7c509d56215b41c3a72e4bc3d741b55b9d3d68f2c9add4d388bdf28af38"
  end

  deprecate! date: "2026-08-28", because: "uses deprecated `gerbv` which needs EOL `gtk+`"
  disable! date: "2027-08-28", because: "uses deprecated `gerbv` which needs EOL `gtk+`"

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "gerbv"
  depends_on "glib"

  def install
    args = ["-DPCB2GCODE_USE_CCACHE=OFF"]
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
