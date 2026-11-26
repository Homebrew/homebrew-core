class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "61b49d45a1abc236021cb06d94402bc834e2575ea47e6afb4bdb158b641b6ef4"
  license "GPL-3.0-or-later"
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "53bac47a19e7f5c9d7fdfb0ca5cd93471d9296ac9c68c7dd9099a3c6b9d18b19"
    sha256 cellar: :any, arm64_golden_gate: "1e539e4140c67de3878df64924d2d57b812a56ce78fb87218050a55fc7568a2f"
    sha256 cellar: :any, arm64_tahoe:       "82b806aef71b91a85d6822f5a74c01a02fddeaf97b44fe3bf053b7245724c936"
    sha256 cellar: :any, arm64_sequoia:     "754b9fc3ace9835df97c70a48d745a7dea4f5c5a505fe336ca54cdb5747f1486"
    sha256 cellar: :any, arm64_linux:       "c82255f4ab635b2fc8095043d7c626710d9fdc5edfe2c97f296100239e0fdb5a"
    sha256 cellar: :any, x86_64_linux:      "ea406021d4eefcf05d6b4ddf1ecd282056cc3e8cafccd1ddcbb70a63ffda68e4"
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
