class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "4953f1a91b8fa4457a54268a9f22f8f596f3ddf5ed10654fd643dbc8112e95b8"
  license "GPL-3.0-or-later"
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "af342b5470bd864588134c70a21ba4ddbaa6e920bbd7bd215255376038a7d5ed"
    sha256 cellar: :any, arm64_golden_gate: "13260e3ae4c71169a04f5ae32aa4e89b73af4222a4fc7c6bf33234045b5e480e"
    sha256 cellar: :any, arm64_tahoe:       "dda865de4463cfa5f56318f9715ac72ee949bc90ba15c1dfe7a281f68577e1a3"
    sha256 cellar: :any, arm64_sequoia:     "ee4c17cac58dc9305118bcb51306c9a96c1a8b47d6073346e13a4171a122496b"
    sha256 cellar: :any, arm64_linux:       "5d42ffe2470c62f9a1feabe41c3c4825011950dc07863cc795db67376a1629c9"
    sha256 cellar: :any, x86_64_linux:      "82bca7900fab6d8bc673c2db6b27077595d99ac58d3c7aae15520766edddc62e"
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
