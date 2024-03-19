class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.9",
      revision: "a17240544b4ac83acf5195c38de1fd1f5f723307"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c28ac6ddb5476afb2a79fb1583319ee4636dcf88fdc99622c18e9a425fddce55"
    sha256 cellar: :any, arm64_ventura:  "39338772277457f3a60a7149cb2e0894443e4fcab67ff094d6276f8eee9174d7"
    sha256 cellar: :any, arm64_monterey: "ba10c8f50b4b4ad148208989545caeb0a5cbaebaac70e74f2adfcbaa838179bc"
    sha256 cellar: :any, sonoma:         "0d628f9aaa7d3784fd7b7937871e036ae1f085d80fa8db03bbe261d44e583195"
    sha256 cellar: :any, ventura:        "6475113ac2c270aad9edfa429b53c4a1781ae8c883693f81daa5c9fea1915ad3"
    sha256 cellar: :any, monterey:       "3ea36e85b718e0e63b1717a6d1836efb7c93d0897892b1823bc7e7acb2660f1d"
    sha256               x86_64_linux:   "800178abd00d66dfdb254a55015b4c0ab4bdbc3f3b3c750271a89b1eadde6709"
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
    url "https://github.com/OpenRCT2/objects/releases/download/v1.4.0/objects.zip"
    sha256 "c7ea3f5c6dfe2ef0a7ac0a428fc9281beac7f5290f0a9ebecbfb6313a3b525d8"
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
