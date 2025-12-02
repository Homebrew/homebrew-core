class Morpheus < Formula
  desc "Modeling environment for multi-cellular systems biology"
  homepage "https://morpheus.gitlab.io/"
  url "https://gitlab.com/morpheus.lab/morpheus/-/archive/v2.3.9/morpheus-v2.3.9.tar.gz"
  sha256 "d27b7c2b5ecf503fd11777b3a75d4658a6926bfd9ae78ef97abf5e9540a6fb29"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:_?\d+)?)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "52e6c2dc8cd3261d122cb100833b7639b74e826bb62c3e65ae83c7028ddd6033"
    sha256                               arm64_sequoia: "86df5016fe99402f8a02f6a21a99519622c57ac3ae150645f2ea701f5e43dc03"
    sha256                               arm64_sonoma:  "e3848e01955a771f9414faa7852bc0162bdb20b2144c21061d890c34b47a4bea"
    sha256 cellar: :any,                 sonoma:        "d7be53ebc4fd1230ebd6b2e5facaf100ce47ef547b5b502728a38e52e3c2171e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aad6af47b8833dbb44fa5f69cce496236ce5eb70cd65b9efe73d55c2bfbf9b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc10f654b9f073a70c202d30192407ce4f1d10c12bdebe9314be6677971e644"
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
