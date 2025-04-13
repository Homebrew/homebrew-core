class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.21",
      revision: "ea5f02a87af0942ee8af4cd2fdda01a95495aafe"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b1b14981ba2076c6b9799fe3b3a0cf71b63cd7072a5ba248a044f7c75dbd09bc"
    sha256 cellar: :any, arm64_sonoma:  "71148a5da892695480c713fefd82b56d8d15146557221890ec0c59f2d40f5928"
    sha256 cellar: :any, sonoma:        "95ed4a17c847c15c6bc50446fa0452111c3122c9b681b5dd881aa8a88b4b90a7"
    sha256               arm64_linux:   "d96749d37f4ef0b399fab3ac22faa83e55dc29aaf37542a4e17e711a44376b95"
    sha256               x86_64_linux:  "7f29f202013cf04b42d50707208133c0be13e6ddb99ed8cbb41e15771ffe22b4"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build

  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c@77"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :sonoma # Needs C++20 features not in Ventura
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
    url "https://github.com/OpenRCT2/objects/releases/download/v1.6.1/objects.zip"
    sha256 "6829186630e52c332b6a4847ebb936c549a522fcadaf8f5e5e4579c4c91a4450"
  end

  resource "openmusic" do
    url "https://github.com/OpenRCT2/OpenMusic/releases/download/v1.6/openmusic.zip"
    sha256 "f097d3a4ccd39f7546f97db3ecb1b8be73648f53b7a7595b86cccbdc1a7557e4"
  end

  resource "opensound" do
    url "https://github.com/OpenRCT2/OpenSoundEffects/releases/download/v1.0.5/opensound.zip"
    sha256 "a952148be164c128e4fd3aea96822e5f051edd9a0b1f2c84de7f7628ce3b2e18"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/sequence").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")
    resource("openmusic").stage do
      (buildpath/"data/assetpack").install Dir["assetpack/*"]
      (buildpath/"data/object/official").install "object/official/music"
    end
    resource("opensound").stage do
      (buildpath/"data/assetpack").install Dir["assetpack/*"]
      (buildpath/"data/object/official").install "object/official/audio"
    end

    args = %w[
      -DWITH_TESTS=OFF
      -DDOWNLOAD_TITLE_SEQUENCES=OFF
      -DDOWNLOAD_OBJECTS=OFF
      -DDOWNLOAD_OPENMSX=OFF
      -DDOWNLOAD_OPENSFX=OFF
      -DMACOS_USE_DEPENDENCIES=OFF
      -DDISABLE_DISCORD_RPC=ON
    ]
    args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # By default, the macOS build only looks for data in app bundle Resources.
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
