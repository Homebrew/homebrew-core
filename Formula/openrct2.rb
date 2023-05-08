class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.5",
      revision: "76ca8400cade0c6de5b47a7e44d405d56f278a83"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ba2ff9328a23b0933e773d82901f8fca44767c6f4579c4cee8821c0dd4c3384e"
    sha256 cellar: :any, arm64_monterey: "c6201a6f73d4ea05f55187c1a95dbaafc1015b23a25bedc61a9089c6768a388e"
    sha256 cellar: :any, arm64_big_sur:  "0fa4b1a2dc9f33dc8d04e2aa3ef2f586736907d9d6f0a762b7b431d0542451aa"
    sha256 cellar: :any, ventura:        "5bbafff0c94cd7a7ad390094b675e501bfa4082ba57faaff2cdd051cced56744"
    sha256 cellar: :any, monterey:       "d105d0ee0cb8a047312a0ab7e8cef18bcce652fca341f41a8d8963bb214e3fe6"
    sha256 cellar: :any, big_sur:        "103da68e12bbbbd98472cc98156776381a36ae4a9fd42f64deaa88a39015d063"
    sha256               x86_64_linux:   "a44c73553830f50fa34304671d2c83068ea7d205eb8e421701af00caf31dc728"
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
    url "https://github.com/OpenRCT2/objects/releases/download/v1.3.8/objects.zip"
    sha256 "84a95590d13a753b1d239f7f06c8d121e36fd28694b21f33646518e2012904ae"
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
