class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/pcb2gcode/pcb2gcode.git", branch: "master"

  stable do
    url "https://github.com/pcb2gcode/pcb2gcode/archive/refs/tags/v3.0.4.tar.gz"
    sha256 "46351d4b7479059becae064cc68f2d1d68d42ae314ff7a1d9a240c71a3c0c98c"

    # Backport fix for newer Boost
    patch do
      url "https://github.com/pcb2gcode/pcb2gcode/commit/1120553b454625a888b113d0f1e241f7f379d771.patch?full_index=1"
      sha256 "f3da7ab233cf12d7d0fa209add3492aed435b5c85f6dd0b89d172f2cc8f3eaac"
      type :backport
    end
    patch do
      url "https://github.com/pcb2gcode/pcb2gcode/commit/b3e196f97fde0a0c5bf5c9c32c163876d13976e1.patch?full_index=1"
      sha256 "eb155e538ba346adfb33027e1b3869c81b12aade39b25f1d1709471f749abecd"
      type :backport
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a61d6217c2ce4a4f285e6a293e9360a37cc5d599176fb8cbf4d73320d92b10a6"
    sha256 cellar: :any, arm64_sequoia: "d2cd1b79a3ef53f44dcc6925326322a1d832e856a912952d0d32bd978d239b56"
    sha256 cellar: :any, arm64_sonoma:  "e327672859159b513ec7bd2f252ab634ff1c2c21a56c69c640d17307eb5c2744"
    sha256 cellar: :any, sonoma:        "bb07d4a6fa70965965d3a0c7033df9873df5c602e1e0e41483fc7241c109a3ed"
    sha256 cellar: :any, arm64_linux:   "5036973bc301e7f18d2a938188a1af76553efe3f15a37e7ff18c8837c4525213"
    sha256 cellar: :any, x86_64_linux:  "616bea02b2e11a5266a152db3d104de5c714be791bb081769c63050e768e7004"
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
