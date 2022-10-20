class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.2",
      revision: "8ceea458774d37ab87fd0e7672180b119f8d8b31"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_monterey: "6ad2c1ef2e5f49fe73ae0d918fc3f6941299e79f56f21d1fba242e8f0a3d4a48"
    sha256 cellar: :any, arm64_big_sur:  "03d952b355b1db4e398b23b7e5668cbdf7f1b458e51389b3528e6538ea4ba1c5"
    sha256 cellar: :any, monterey:       "b372100620c71a46d88dc9fe17e777bf7ab0af7eadd59d6c948a957e77101892"
    sha256 cellar: :any, big_sur:        "f6ed0d0a300fca742fdbd80273246b701802941581c522b47942cef5f8de7b0b"
    sha256 cellar: :any, catalina:       "af6dcce43bee1412dd9c832111fbdca9fcd2236f1be5710e3733a3d58760a2ee"
    sha256               x86_64_linux:   "d54175b7b577d6a21f9471022fdb72d2678cdeef682384bdd246718302ec5ef5"
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
    url "https://github.com/OpenRCT2/objects/releases/download/v1.3.5/objects.zip"
    sha256 "4859b7a443d0969cb1c639202fe70f40ac4c2625830657c72645d987912258ff"
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
