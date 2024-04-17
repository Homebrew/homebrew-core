class Morpheus < Formula
  desc "Modeling environment for multi-cellular systems biology"
  homepage "https://morpheus.gitlab.io/"
  url "https://gitlab.com/morpheus.lab/morpheus/-/archive/v2.3.7/morpheus-v2.3.7.tar.gz"
  sha256 "ad5694a098e4752db53659ee983c3ae417a43747320e73c3005f6cf88b52d55c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:_?\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7499f7a4721755466ae1b38cb3b5a55ba2fc5ca471232cc7e320b5d04fcf0fcd"
    sha256 cellar: :any,                 arm64_ventura:  "ce0249b648e88ae685c1379b4fc58869408782b6e50b883d67d2edd4d95066b3"
    sha256 cellar: :any,                 arm64_monterey: "a5714a265b96b9a7c926a2d155f8f78d8c090770a064c52757df37e682d661ed"
    sha256 cellar: :any,                 sonoma:         "1aec65d363df33f6b118d2c6689827fe94718e24570e6aaf74f1e85860a05ce1"
    sha256 cellar: :any,                 ventura:        "681c8ba46b7daa01fa5aaaca1a02ac3bb710e078afa143699d2adcc9adbbb496"
    sha256 cellar: :any,                 monterey:       "8f1c56a3f7ef13f0d6cb8438c9ddd62df813cf0912edf8e15cc93a1040458331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7e3beee556888d39c5447fa3e32d50e565529376dc153d93e419be0a025aa35"
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
