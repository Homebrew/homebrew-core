class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.1",
      revision: "be518f48e34184674cf176102d343e539b20549e"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_monterey: "e9219ea06c9a72777438ddfaf468304d3c26cc2a48265409fe75753259faad51"
    sha256 cellar: :any, arm64_big_sur:  "7850b2d1bf43757c9de7e4ea05a498bf38b9d228ac6f3ee0758363b2a61eb3f7"
    sha256 cellar: :any, monterey:       "0bf9bbfc2bc03af5a44c6286b5b58279a89aa7c6a977c8e2f7f858e4c35865c0"
    sha256 cellar: :any, big_sur:        "8f2cbe09ce6f87fa194873603dc7a45fb6c5dc81b917a2f15625ed39ee2f801a"
    sha256 cellar: :any, catalina:       "2616fd5667289a8b86867e895aa71ec55d00d46fc4580bf871ca4ffd283c8a1a"
    sha256               x86_64_linux:   "3a2f4d46ec6e13f0ee8a4c4926ae37e5513d410801e5c7603858035db2e4d7af"
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
    url "https://github.com/OpenRCT2/objects/archive/v1.3.2.tar.gz"
    sha256 "9c94e479ce676076c739a05edbd9196860d1baecff8753c378043dcea8e0b63b"
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
