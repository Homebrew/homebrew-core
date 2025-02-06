class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.19.1",
      revision: "455f22bbca7b519f41d90705ee323df36b37ed9a"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "86aae64d8ad18ce9a6327e115cbfefebae4501f2c3300818494bf6699126909b"
    sha256 cellar: :any, arm64_sonoma:  "3b0604e8e2ca3e8914a4498ea2bec170aefcb3d915f4f888eae6c9b6a70e9399"
    sha256 cellar: :any, arm64_ventura: "06383760512c04c3a485d091b26868a84a14856f0f8a27bec8205625dfcd03fe"
    sha256 cellar: :any, sonoma:        "089b97c152fc0fc834b4c8980cf2f19111ff24db730d7ecedc94cbd848fd120f"
    sha256 cellar: :any, ventura:       "4fabadb5bca04493efe0eead740fbce11a8bc3e9a829c0d40e0b512a3863853e"
    sha256               x86_64_linux:  "1adf7ea3752b086c8ce6e8c92b113ad72557aff99b61620dc22d540f0d989eb2"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build

  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c@76"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "speexdsp"

  uses_from_macos "zlib"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  resource "title-sequences" do
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.4.14/title-sequences.zip"
    sha256 "140df714e806fed411cc49763e7f16b0fcf2a487a57001d1e50fce8f9148a9f3"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/releases/download/v1.5.1/objects.zip"
    sha256 "c6b800cbcd7b1b9c707f3657fbc5f2db9d3cfd9c2adf668accc9ddbacd7841df"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/title").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")

    args = [
      "-DWITH_TESTS=OFF",
      "-DDOWNLOAD_TITLE_SEQUENCES=OFF",
      "-DDOWNLOAD_OBJECTS=OFF",
      "-DMACOS_USE_DEPENDENCIES=OFF",
      "-DDISABLE_DISCORD_RPC=ON",
    ]
    args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # By default macOS build only looks up data in app bundle Resources
    libexec.install bin/"openrct2"
    (bin/"openrct2").write <<~BASH
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    BASH
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
