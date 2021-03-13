class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.3.3",
      revision: "3f65f282d7332c284dcb5daaf4c278b7e9da9b92"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0f4f413c60ed59b2c91adf12e74580b3771e0ca998e8106cf827db4c82c80809"
    sha256 cellar: :any, big_sur:       "19aa37014ea1084321c30dbf71df1e497258778ba72ff67bf44354292176c947"
    sha256 cellar: :any, catalina:      "853ff9443771afa9781da85a6c2a18b3809603c8e0ffa0016945c181f584c986"
    sha256 cellar: :any, mojave:        "0049af69a5663de01fab0375006b085585b3561c8fc34f3499b1cc54f522cadd"
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

  resource "title-sequences" do
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.1.2c/title-sequences.zip"
    sha256 "5284333fa501270835b5f0cf420cb52155742335f5658d7889ea35d136b52517"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/archive/v1.0.21.tar.gz"
    sha256 "31129188916dc9ba2318d851e03393ce55782f121ab7c9d97544abdc7bbc92ab"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/title").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
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
