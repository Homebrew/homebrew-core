class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.18",
      revision: "8c19879e6f0cb13a63569a20f6ccaf0d9c739b39"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "a0d33950d824e1fd2a8fe54d2228021454ffb055502575ebcfbb9a5ae0a73128"
    sha256 cellar: :any, arm64_sonoma:  "041169077a1238481b811f7adcccaee5601c55317a01e6e9ffac2609f73cd450"
    sha256 cellar: :any, arm64_ventura: "557d7e96e17a485d4eb7001a0fd4a5c845708818bf298c9a3e3939b6e75ba5e0"
    sha256 cellar: :any, sonoma:        "572eba332c707b94c5e2de08d17b75622f10186a6206f4d4b14df1366e48088d"
    sha256 cellar: :any, ventura:       "f7285ec45d7e287eca9bd7212a64ee98e539bc75c64d312ac25d8eb1f73fdbca"
    sha256               x86_64_linux:  "d2768df4e844578690792a3a5dabd4530526d7cebf208c67e98420d3f2f4c6c0"
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
    url "https://github.com/OpenRCT2/objects/releases/download/v1.4.12/objects.zip"
    sha256 "6417dad971674e5cf39bf56e83e04e4086547145e3fac696f163037fe841e7be"
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
