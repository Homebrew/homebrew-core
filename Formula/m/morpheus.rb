class Morpheus < Formula
  desc "Modeling environment for multi-cellular systems biology"
  homepage "https://morpheus.gitlab.io/"
  url "https://gitlab.com/morpheus.lab/morpheus/-/archive/v2.3.8/morpheus-v2.3.8.tar.gz"
  sha256 "d4f4d3434fadbb149a52da2840d248176fe216a515f50a7ef904e22623f2e85c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:_?\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fed9b4e1881854ccb426eb5d08509765e3c449f3bfbe6aacece88157ff754686"
    sha256 cellar: :any,                 arm64_sonoma:   "62411dd8e6cd7ad86d4e20468224c0b2c07d4156b0985d868ef29549f916447c"
    sha256 cellar: :any,                 arm64_ventura:  "7a9e5a6470fb2c847cf7ea02ea7684a02b0bb1a964696f8dc7d9fd8423805a05"
    sha256 cellar: :any,                 arm64_monterey: "9a4bee42a65cb59f1706e24174927a7fca699eaa4fe6d766fbdd5e924c5218da"
    sha256 cellar: :any,                 sonoma:         "35891458eaa826d5a06d5be21756cb552e829ce16a53c7c292a022a05fdb5dbd"
    sha256 cellar: :any,                 ventura:        "ac28538de739b8825d66e3042aa27d3a8d740708b2ab9502b1f5d717e1d45ede"
    sha256 cellar: :any,                 monterey:       "65b7e005a0575c0e1729d658bef5767ec721b2b8cf9bb7dac4627dc574d11a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03b034c07167ea28a82d43f8893f5f82c7213d91d68db687409480cf274b94d2"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "ffmpeg"
  depends_on "graphviz"
  depends_on "libomp"
  depends_on "libtiff"
  depends_on "qt@5"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # has to build with Ninja until: https://gitlab.kitware.com/cmake/cmake/-/issues/25142
    args = ["-G Ninja"]

    if OS.mac?
      args << "-DMORPHEUS_RELEASE_BUNDLE=ON"
      args << "-DBREW_FORMULA_DEPLOYMENT=ON"
      args << "-DMORPHEUS_SBML=OFF" # SBML import currently disabled due to libSBML build errors with some macOS SDKs
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    bin.write_exec_script "#{prefix}/Morpheus.app/Contents/MacOS/morpheus"
    bin.write_exec_script "#{prefix}/Morpheus.app/Contents/MacOS/morpheus-gui"

    # Set PATH environment variable including Homebrew prefix in macOS app bundle
    inreplace "#{prefix}/Morpheus.app/Contents/Info.plist", "HOMEBREW_BIN_PATH", "#{HOMEBREW_PREFIX}/bin"
  end

  test do
    (testpath/"test.xml").write <<~EOF
      <?xml version='1.0' encoding='UTF-8'?>
      <MorpheusModel version="4">
          <Description>
              <Details></Details>
              <Title></Title>
          </Description>
          <Space>
              <Lattice class="linear">
                  <Neighborhood>
                      <Order>1</Order>
                  </Neighborhood>
                  <Size value="100,  0.0,  0.0" symbol="size"/>
              </Lattice>
              <SpaceSymbol symbol="space"/>
          </Space>
          <Time>
              <StartTime value="0"/>
              <StopTime value="0"/>
              <TimeSymbol symbol="time"/>
          </Time>
          <Analysis>
              <ModelGraph include-tags="#untagged" format="dot" reduced="false"/>
          </Analysis>
      </MorpheusModel>
    EOF

    assert_match "Simulation finished", shell_output("#{bin}/morpheus --file test.xml")
  end
end
