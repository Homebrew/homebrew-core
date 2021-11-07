class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.3.5",
      revision: "b9bc8d0606845e4e73fda8b459a55650f23164de"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_monterey: "fc96408e8a7f9cbb7b47e92a34460f6baf92bef43c83af59d03f9d43319f4d99"
    sha256 cellar: :any, arm64_big_sur:  "5a75b78d7d74c9eaadff1867bededb84553bf087d1487b54f0fa1899d405b15d"
    sha256 cellar: :any, monterey:       "709354e6c2d4cc68facff3b95a1bf58800df31ca28bb52f9cba4247647e7708e"
    sha256 cellar: :any, big_sur:        "3027a49a14f166ba899a076e5b62648f49a312fb62da37e21c81959463da91c5"
    sha256 cellar: :any, catalina:       "6991d066861d381439123af05c53baa20bf70d5e36cea9475d6aa50564e1830e"
    sha256 cellar: :any, mojave:         "d6ee68373bc7d6d0af9a61f92b2f11ec68584fdf39a8960c53345ac3115559e7"
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
