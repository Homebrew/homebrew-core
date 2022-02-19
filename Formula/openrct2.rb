class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.3.5.1",
      revision: "61c67afc667bfee8a6c3b180e98e84e87f442550"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "99b8f59ade1d666eb18777b1a51af0b7ccf36e9a6664a5bda685faa9fd6976da"
    sha256 cellar: :any,                 arm64_big_sur:  "e37538f06c13b93c156fbca46442e2c60fe4feff69b79e5c6f20c05ede878a74"
    sha256 cellar: :any,                 monterey:       "933b222bc429f24ed5a8f6a8f0682fdc3218b68a192be612be54493caec55b22"
    sha256 cellar: :any,                 big_sur:        "2d2b86bab2dc4d14c4813588cc8ea45aa85ba24e17eef7a02961cef809c7bd13"
    sha256 cellar: :any,                 catalina:       "0b027b8b473e74a0f70c4576d08c0a24377e334dd0ee18e5813135989f52dfc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3470fa8440c040938e8e4dbb46f05ab20110a18b4c3b8a8276ffb1f69f3464c6"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkg-config" => :build
  depends_on "duktape"
  depends_on "freetype"
  depends_on "icu4c"
  depends_on "libpng"
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
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.1.2c/title-sequences.zip"
    sha256 "5284333fa501270835b5f0cf420cb52155742335f5658d7889ea35d136b52517"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/archive/v1.2.2.tar.gz"
    sha256 "f24ed11bc21473c3eee3be3fd0f776e542af408b3b408eb6c35f6115b1bed89d"
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
