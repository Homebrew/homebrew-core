class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.13",
      revision: "caacd4d7be8258e3e3f2b69c9d87eecc2b4ac119"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "006070c6c8123bc039e6b12c31de8ebe465ae1710f629ec72fd9acaa13299194"
    sha256 cellar: :any, arm64_ventura:  "1f7615e92ed702fee21c79e774b180a8cbb88b717a35cd04d05ab2508db9f48f"
    sha256 cellar: :any, arm64_monterey: "4c57c7239264fe74be3b577be885afcb5c20de864a3df739a90baee630736f74"
    sha256 cellar: :any, sonoma:         "4386aa5b5cf656a72fe46c99402e1e73e2819f058bc2b8121851b4abaddd716c"
    sha256 cellar: :any, ventura:        "45d0032453c57171c6f4bb2078bf174f8bfa7aa625acad24d4d62d1e6e0d871e"
    sha256 cellar: :any, monterey:       "50d1bfc7c87cddbb9d0e495f52907675913d343cd7d59b3f5d7075ee411c601e"
    sha256               x86_64_linux:   "f700047fad17997749d81e4c1736ca762f8f9d48ab03af93709ae750e004ac72"
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

  uses_from_macos "zlib"

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
    url "https://github.com/OpenRCT2/objects/releases/download/v1.4.7/objects.zip"
    sha256 "003c7d8a68a2461ac27204a361ffe6eab66e3aff262755b9830c97ce36d6fb65"
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
    (bin/"openrct2").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
