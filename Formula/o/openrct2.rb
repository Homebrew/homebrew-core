class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.6",
      revision: "b40b5da5a570155298335e276839a41588337b5d"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1c94a3bc76cbc4e9fd7e5662a37bc87659931e87a584c1e2ef6827d79022b96c"
    sha256 cellar: :any, arm64_ventura:  "df51696476437df5af49a0755f922980dc77b7f718c30c7acc41e7687d3d642d"
    sha256 cellar: :any, arm64_monterey: "afe6bb0c3a677b1a78a4b521d0ee82b15c6d8896e85ed681b5d3ddc3990f6dab"
    sha256 cellar: :any, arm64_big_sur:  "73210c0f7679527a8351793507e5ed96e586e11a6f627dea35b85d421c4aaaee"
    sha256 cellar: :any, sonoma:         "135bc5f9ebeac6cdf165ec962986476368a5d3a1daf1daceca87761204f25bef"
    sha256 cellar: :any, ventura:        "740c9900c72268bf5761b53940155b55eba9a860b3514c91b6fff0a08492a390"
    sha256 cellar: :any, monterey:       "9b1569c5e1c2422912bb3170a5f95378a3e2e6d1d4ea9ea9379e399ec3e5505f"
    sha256 cellar: :any, big_sur:        "84a3d5a9a7c135e5d33a0769a5c4c79e2281d66e1d54eb50859b1ea2be49f67b"
    sha256               x86_64_linux:   "89076f1b729d47de34afbe3932c5b964338e234fb70859b67eb82c09d1d25662"
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
    url "https://github.com/OpenRCT2/objects/releases/download/v1.3.11/objects.zip"
    sha256 "bf85d88e4fb11ca2e5915567390898747dc2459b3c7a057bdc32b829c91780b4"
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
