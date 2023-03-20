class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.3",
      revision: "285e0fc42e4c3b484083f9708c87732ed991a78b"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "6c98ffcfcbe4b52e25b4d95f95b270a7dac30eca2dbcfd23548d694f982ab899"
    sha256 cellar: :any, arm64_monterey: "f64704fd0e24177eb862a195f2498d3d4455f7b83d87bdd59fc08138d09dc527"
    sha256 cellar: :any, arm64_big_sur:  "accfc705bb5a13de21f53e7c45ce1dd5a69b441dbd384d599908b713ca4ca2a1"
    sha256 cellar: :any, ventura:        "92ffd3be786a3d04fe76c161d39730821ef116d98f5f9645f5181117c82ea08b"
    sha256 cellar: :any, monterey:       "c6c823edf41309cc13fd0fab677954ed89728222ee16456b2d66103eea60a605"
    sha256 cellar: :any, big_sur:        "572a50f56b3e3e7b4ac6bd966caf58a2ef1ceed220fe56ee8dba91eb6c06884d"
    sha256               x86_64_linux:   "909bee36382ffac72e573e6b924bfcf30bce05badb06631645be9141f4c4bd65"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkg-config" => :build
  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "openssl@1.1"
  depends_on "sdl2"
  depends_on "speexdsp"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  fails_with gcc: "5" # C++17

  resource "title-sequences" do
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.4.0/title-sequences.zip"
    sha256 "6e7c7b554717072bfc7acb96fd0101dc8e7f0ea0ea316367a05c2e92950c9029"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/releases/download/v1.3.7/objects.zip"
    sha256 "d6be9743c68f233674f5549204637b1f0304d7567a816d18e3f1576500a51d38"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/title").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}",
                            "-DWITH_TESTS=OFF",
                            "-DDOWNLOAD_TITLE_SEQUENCES=OFF",
                            "-DDOWNLOAD_OBJECTS=OFF",
                            "-DMACOS_USE_DEPENDENCIES=OFF",
                            "-DDISABLE_DISCORD_RPC=ON"
      system "make", "install"
    end

    # By default macOS build only looks up data in app bundle Resources
    libexec.install bin/"openrct2"
    (bin/"openrct2").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
