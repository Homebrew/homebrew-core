class Morpheus < Formula
  desc "Modeling environment for multi-cellular systems biology"
  homepage "https://morpheus.gitlab.io/"
  url "https://gitlab.com/morpheus.lab/morpheus/-/archive/v2.3.9/morpheus-v2.3.9.tar.gz"
  sha256 "d27b7c2b5ecf503fd11777b3a75d4658a6926bfd9ae78ef97abf5e9540a6fb29"
  license "BSD-3-Clause"
  revision 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:_?\d+)?)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "68e93247aebdf994cf0792d3734daa663aa4fdac54275e1c6a9844d542af10d2"
    sha256                               arm64_sequoia: "b823163069bb353ba32a2055f4a8bffc20ff29195454e95fb65d1c65fae15ce7"
    sha256                               arm64_sonoma:  "cbcb607a2cfffb3abab6139a790f4ead1d2f57a317b73e7ba7eae2a1ea2ea075"
    sha256 cellar: :any,                 sonoma:        "f4226960321c42c64a88a366aee6dc2ffc3eb6d6f76629ac839e209dde430181"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae058fa9e0ac6939094dc571369a614dc2f39da0491875ce354fa1c01141b363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "167d9a671a465a72eec47bc03748732688e8b768ac05eebe308e847e0798fab5"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  # Backport support for CMake 4
  patch do
    url "https://gitlab.com/morpheus.lab/morpheus/-/commit/74aa906b9c2bd9144776118e61ffef3220a70878.diff"
    sha256 "7d186bcd41b640e770f592053f25a4216c57ae56e5ecee68f271e8d00fbfa4a1"
  end
  patch do
    url "https://gitlab.com/morpheus.lab/morpheus/-/commit/aac15ea4e196083a00c0634d1aaa6d49875721c7.diff"
    sha256 "2e6f40b7acf4b81643b5af411f1e6bb8d7bc01282a638488c8be41fbdbb68675"
  end
  patch do
    url "https://gitlab.com/morpheus.lab/morpheus/-/commit/8c5035ef693068a1ddcfdc710f45bd4f4663ee8b.diff"
    sha256 "e0916157e4c32c7370f3b0a140b43c4a30c2173c9a65e73c2dd6a817011920ed"
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
