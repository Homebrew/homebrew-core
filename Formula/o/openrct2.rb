class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.8",
      revision: "05efdb2497676e8970876c068c4825fb382c1a8a"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9aae9c1e6fa509f04d5bdba4889ec816cf88495da103f3c6a28969fd1db5fadf"
    sha256 cellar: :any, arm64_ventura:  "231e11c2bd0aa0447eb0e6a62dbe9e3e816dc632a14de9c17dbcfa803c0bdad3"
    sha256 cellar: :any, arm64_monterey: "0b30728151da7c3dcb250cb9c49aa73c3515a638e1b0c9951e9070d31d6e5a9a"
    sha256 cellar: :any, sonoma:         "2907e1639e75f0434f71f534bd2b004b057a0810910103af71f42edb6ca616cf"
    sha256 cellar: :any, ventura:        "ad1ef1684188c56a6a5f64bf11bf746d4ba6bb7f717221a5b99f9e86f2bdfa67"
    sha256 cellar: :any, monterey:       "6e77d1f20638912dec3a254ce3c4062a72377924dafb63798c53d678a499355b"
    sha256               x86_64_linux:   "5b78f3bf349c6dccea0d363050fd80c34469eff17825926f46a393e3401e991e"
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
    url "https://github.com/OpenRCT2/objects/releases/download/v1.3.13/objects.zip"
    sha256 "0711779d69778652d4430d4173903e2444673be374b0ed78c797b5636349b968"
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
