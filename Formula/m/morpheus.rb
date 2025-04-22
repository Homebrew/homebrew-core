class Morpheus < Formula
  desc "Modeling environment for multi-cellular systems biology"
  homepage "https://morpheus.gitlab.io/"
  url "https://gitlab.com/morpheus.lab/morpheus/-/archive/v2.3.9/morpheus-v2.3.9.tar.gz"
  sha256 "d27b7c2b5ecf503fd11777b3a75d4658a6926bfd9ae78ef97abf5e9540a6fb29"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:_?\d+)?)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "11e3811c5e5932f71678bea042c542a8a9ca5e0e24be85d4ce37f04b2096af1f"
    sha256                               arm64_sonoma:  "5875ccd833c4e41e3c0d6a92a6e345bebf5b79cb6fddde17e25383dc20a7330c"
    sha256                               arm64_ventura: "e7e28d8b1bd4020ca3e99ddcceeb9c3af6abc63bb4bdc60bfd6302f04f50d849"
    sha256 cellar: :any,                 sonoma:        "31b3c036148a0c2ffbd42abc324e85fd5709323ef52977340b128ff92cac7c86"
    sha256 cellar: :any,                 ventura:       "29d8f5b2730cbda1d887ea580c643d26f80bcd224de09f27245595361f820862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac0786ead33d0beb6c8fd5ba6554e2de1df213ba821576fa849a1a8dff1fb4a0"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "ffmpeg"
  depends_on "graphviz"
  depends_on "libtiff"
  depends_on "qt@5"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    # has to build with Ninja until: https://gitlab.kitware.com/cmake/cmake/-/issues/25142
    args = ["-G", "Ninja"]

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

  def post_install
    # Sign to ensure proper execution of the app bundle
    system "/usr/bin/codesign", "-f", "-s", "-", "#{prefix}/Morpheus.app" if OS.mac? && Hardware::CPU.arm?
  end

  test do
    (testpath/"test.xml").write <<~XML
      <?xml version='1.0' encoding='UTF-8'?>
      <MorpheusModel version="4">
          <Description>
              <Details></Details>
              <Title></Title>
          </Description>
          <Space>
              <Lattice class="linear">
                  <Neighborhood>
                      <Order>optimal</Order>
                  </Neighborhood>
                  <Size symbol="size" value="1.0, 1.0, 0.0"/>
              </Lattice>
              <SpaceSymbol symbol="space"/>
          </Space>
          <Time>
              <StartTime value="0"/>
              <StopTime value="0"/>
              <TimeSymbol symbol="time"/>
          </Time>
          <Analysis>
              <ModelGraph format="dot" reduced="false" include-tags="#untagged"/>
          </Analysis>
      </MorpheusModel>
    XML

    assert_match "Simulation finished", shell_output("#{bin}/morpheus --file test.xml")
  end
end
