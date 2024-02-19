class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.8",
      revision: "05efdb2497676e8970876c068c4825fb382c1a8a"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "30aa9b73fe14c397f9c676e6b059618b8acb2566eeb6e60e83bb8228bde7187b"
    sha256 cellar: :any, arm64_ventura:  "38742b4d2a72ae9001ca4223a89face3304cf4b60ebaefa605a8c65d3078ab4d"
    sha256 cellar: :any, arm64_monterey: "23a8d33af4e4d36f567b07f5755d8ecfaac80cbe21e2889b85c97f454a3be086"
    sha256 cellar: :any, sonoma:         "70e639796d92bd4a9105893189fed0a169961850eebea5c9403fa5eb92c3cc98"
    sha256 cellar: :any, ventura:        "1a6cfb2d3b96a3fc8f61e070a9069085526ef813c2f0a7a9c4f569bf1269efa9"
    sha256 cellar: :any, monterey:       "f35e54d03a074b196b690fad5c74d27c98b35ac130137907de4d38ee9f66fc27"
    sha256               x86_64_linux:   "ff053044e04e57efc51894b99c25b2e04b3eedb5ea80bad6cad26512332fff70"
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
