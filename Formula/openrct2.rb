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
    sha256 cellar: :any, arm64_ventura:  "6d1d411c463ad5c1d65cf21c6e6d170d96d552adab11bc52a7e1a18d9fc42a86"
    sha256 cellar: :any, arm64_monterey: "a95173b7676fc61621183226a3dcfa039fce904a131bbd5cdc02cb15f1bb9094"
    sha256 cellar: :any, arm64_big_sur:  "ed6313f8f07bdfdc742883dfbc8cf89aae53ed98ff87d64b4a1a66fec3e5702f"
    sha256 cellar: :any, ventura:        "0aec84f8c1fa67f1fb8978ea03f1da2c52be5993ddde8542b4b2e60943023dff"
    sha256 cellar: :any, monterey:       "aaaef0b4a369b924f378cf6a7e36823c9bfd066065e1d526193ecccee0000845"
    sha256 cellar: :any, big_sur:        "5c5c10a0507cc1d061781e3fe2cf7dbeb756c7e51f86d4383533ac34f8297557"
    sha256               x86_64_linux:   "c827a70371629f06feef8f64ed46b1cddd1f0e675c4d80b68b6aa94e4c94ae6b"
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
