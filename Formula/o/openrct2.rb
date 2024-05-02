class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.10",
      revision: "e55d761eb7029a496851cf16ac22a591a2fcd040"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9b20c4b97df4786adaf92809243d39ef46a33e790412e3db9c655661196943f1"
    sha256 cellar: :any, arm64_ventura:  "11d19946c9435319577bc33d8da95cdc44af6bb7dd364b91f5485ab7a9554646"
    sha256 cellar: :any, arm64_monterey: "5d8791fd2655ac6aa5ead783ff4ebb6821dafb9586a6c0450d71aa37807143b1"
    sha256 cellar: :any, sonoma:         "45d6bf2e9099be7c37ec3e2bb5739638597c120053bff484af01db046ea20cbf"
    sha256 cellar: :any, ventura:        "bb7a6013a0619b16d5407a49c759ba947a9350656a8e9a4d244ebbe6986a2aaf"
    sha256 cellar: :any, monterey:       "5d13ff766561b3b764f7ced207d5744f0e4ae350746f5c187092dc72b0770005"
    sha256               x86_64_linux:   "22cf031d2f24f2e38d0f36d1398c06208e2878f5636b7e0ae0a518fd9c4f218d"
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
    url "https://github.com/OpenRCT2/objects/releases/download/v1.4.3/objects.zip"
    sha256 "cc2c8304e35337fb7b4daffa9b0ad1afa9a9f3f8f895817671a71c665d372764"
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
