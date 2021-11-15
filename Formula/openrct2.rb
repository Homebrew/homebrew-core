class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.3.5",
      revision: "b9bc8d0606845e4e73fda8b459a55650f23164de"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2a33b05f9b7ff6cf1d2981a6e952c76e0a4556631826d8438ba52648c4a76082"
    sha256 cellar: :any,                 arm64_big_sur:  "83710494471e0b55b7fcb34ca3f08543e030636b53e5abbe4ee09612d778a780"
    sha256 cellar: :any,                 monterey:       "c68fda61f393be48046836f030955e39282d51e8d80a7f705fd2b5f6e9ad614b"
    sha256 cellar: :any,                 big_sur:        "2e537256b7eff79490790df7929cae4dbb3f2808a64f1e1c906ae7915aadbc8c"
    sha256 cellar: :any,                 catalina:       "776380b5d7a49bb24b941a8ed44958e28cfcef6f4cb82a88b0bcd5174451f8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77175013706a40ecddd0409dfc09fd6c4f11651b87024431baeec1151a56d41a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "duktape"
  depends_on "freetype" # for sdl2_ttf
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "libzip"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "nlohmann-json"
  depends_on "openssl@1.1"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
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
