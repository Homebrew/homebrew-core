class Morpheus < Formula
  desc "Modeling environment for multi-cellular systems biology"
  homepage "https://morpheus.gitlab.io/"
  url "https://gitlab.com/morpheus.lab/morpheus/-/archive/v2.4.0/morpheus-v2.4.0.tar.gz"
  sha256 "a8870886dce9a3bc2f54f5156318cad39d2efbdf7ea3f91c15487f8d8315bb06"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:_?\d+)?)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "806fb82908295c5ff46eadca55c3e6637464dd91a506240e3742c1a0974a8a90"
    sha256                               arm64_sequoia: "f8c4df3f8309e407136928bd026e568edd110b2ec5e53e000a0b0eee919a2a2a"
    sha256                               arm64_sonoma:  "21c4ebcbd80377921781da230b5db06c91082c468fb936fe45bccd44f4eefe8c"
    sha256 cellar: :any,                 sonoma:        "05b7a4d57d8840eeb4435da5b676659db05ec6ec53f7c08b08b791d83ec24d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0710934d74095db277593d957838dfa6291bebe367b77a90e4d6a20146394703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9dd587eded85779db5e2de292c8c6554784095260e6fc43e544f19de389007d"
  end

  # Can undeprecate if new release with Qt 6 support is available.
  deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "boost"
  depends_on "ffmpeg"
  depends_on "graphviz"
  depends_on "libtiff"
  depends_on "qt@5"

  uses_from_macos "libxslt" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Avoid statically linking to Boost libraries when `-DBUILD_TESTING=OFF`
    cmakelists = ["CMakeLists.txt", "morpheus/CMakeLists.txt"]
    inreplace cmakelists, "set(Boost_USE_STATIC_LIBS ON)", "set(Boost_USE_STATIC_LIBS OFF)"

    # Workaround for newer Clang
    # error: a template argument list is expected after a name prefixed by the template keyword
    ENV.append_to_cflags "-Wno-missing-template-arg-list-after-template-kw" if OS.mac?

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
