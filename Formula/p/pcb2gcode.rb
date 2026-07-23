class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "46351d4b7479059becae064cc68f2d1d68d42ae314ff7a1d9a240c71a3c0c98c"
  license "GPL-3.0-or-later"
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a0ee0759888cdc1df63db194da77d2d1964e3ca80149364809117b388090cdbb"
    sha256 cellar: :any,                 arm64_sequoia: "1cb1185825413d823d5c5db4886a69942d932a909627a4136df485c8375c883d"
    sha256 cellar: :any,                 arm64_sonoma:  "9c6d3d7d32f25c17bdaf908eff61bd3ff2660fde46d03baf3336f422f488723d"
    sha256 cellar: :any,                 sonoma:        "67c13b9634a892c495204267d66b00635dbeb7ffe24ee088bffc61c18528f058"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccf34a378edf5529f4a112acbc65ce4ddf2ff209eb5651221615ea014009ba44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0788506858ed2a230f70518f05581ea109f6425593e7a74f78667067272a3215"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
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
