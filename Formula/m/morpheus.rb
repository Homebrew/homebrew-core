class Morpheus < Formula
  desc "Modeling environment for multi-cellular systems biology"
  homepage "https://morpheus.gitlab.io/"
  url "https://gitlab.com/morpheus.lab/morpheus/-/archive/v2.4.1/morpheus-v2.4.1.tar.gz"
  sha256 "27da3928bfbc58c592d598a0c91b81990b97f0e37c00d1b8071fc208d91875fc"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:_?\d+)?)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "72759851ae282a2ba52bea87780c8cdcb7f9dc7d8e852bfc1cd5506a5a07bebe"
    sha256               arm64_sequoia: "4d8cf6c34f1211ff2058cc07a52ebb8fa3f9873cf2e2e30a35e0220b6bac4322"
    sha256               arm64_sonoma:  "9def5c730d929ec321454ad5a06124aa18b3604c227fa188edd74272a118ec11"
    sha256 cellar: :any, sonoma:        "4fa0385a3b6ffd3d62746874bb27165c8a6680bcfa1ccd01b1f89e819114784f"
    sha256 cellar: :any, arm64_linux:   "1f447e55fa70882c92a2b8f98d6c76f86ef6b12a47dd03a62f6a98f6857dac23"
    sha256 cellar: :any, x86_64_linux:  "eb68b74d3c70d48d28d3cd1a52bb8ec318a9e64361551298424fdbd89128a614"
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

    (libexec/"post-install").write <<~SH
      #!/bin/sh
      [ "$(uname -m)" = "arm64" ] || exit 0
      exec /usr/bin/codesign -f -s - "#{opt_prefix}/Morpheus.app"
    SH
    chmod 0755, libexec/"post-install"
  end

  post_install_steps do
    on_macos do
      run "post-install", base: :libexec
    end
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
