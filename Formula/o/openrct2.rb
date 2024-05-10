class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.11",
      revision: "18d2b5ef6e02fe6a702dca04e95371e8dd60b4ec"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5ce75153a7f7612d0f58e3f6ba4f158f3c5eb531a5c269dd95f180940f340643"
    sha256 cellar: :any, arm64_ventura:  "a362d1e4ddede47c09dcc95543bdc62a83caf7a8ad42780438658045ed5c808c"
    sha256 cellar: :any, arm64_monterey: "a331b06f8d53d62d26088bda7554f78b87426ee301c305708cf7730e712427ef"
    sha256 cellar: :any, sonoma:         "fe3058924ce5fbee3cef48d25abc8ddfb2f321e099e23bda2a2e046c7ba2d927"
    sha256 cellar: :any, ventura:        "e68dce1d40ff3d3e57091b5bf7f17f8f12627d739e62f66e6200fddecd790094"
    sha256 cellar: :any, monterey:       "03b739bf5751c063d8ff473be79d6c3b0f96ed2bebe9d511b6a05d85f111c0ce"
    sha256               x86_64_linux:   "9fcc0f6f48c887dc2afe205844520158101f9b39ade7f00a4aff79aae743d306"
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
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "speexdsp"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  fails_with gcc: "5" # C++17

  resource "title-sequences" do
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.4.6/title-sequences.zip"
    sha256 "24a189cdaf1f78fb6d6caede8f1ab3cedf8ab9f819cd2260a09b2cce4c710d98"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/releases/download/v1.4.4/objects.zip"
    sha256 "da017b90a3870649cb4ff22e14edfc746259af048967311d1133cf4c836ae5a0"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/title").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")

    mkdir "build" do
      cmake_args = [
        "-DWITH_TESTS=OFF",
        "-DDOWNLOAD_TITLE_SEQUENCES=OFF",
        "-DDOWNLOAD_OBJECTS=OFF",
        "-DMACOS_USE_DEPENDENCIES=OFF",
        "-DDISABLE_DISCORD_RPC=ON",
      ]
      cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?
      system "cmake", "..", *std_cmake_args, *cmake_args

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
