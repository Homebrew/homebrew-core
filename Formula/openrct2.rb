class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.0",
      revision: "c6302a1dae09e2539ed053390ca0dd1816448a14"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a2ee8367042840c57fa5d75a7251645b04a44367fd3b1c5a3d6080df09fb1bbf"
    sha256 cellar: :any, arm64_big_sur:  "00d148141e96617fe0329c19758dbc9389548ef095085fa032e8b6f46f5865e5"
    sha256 cellar: :any, monterey:       "0a201d49bb9c2470052dc7ad589d0b45f4398a8ecc3b685660795ebca3334955"
    sha256 cellar: :any, big_sur:        "c2c92d7f274ad0e3b367ab44726890d0acd00cc6beecb4260c760d14f6f00a4d"
    sha256 cellar: :any, catalina:       "9444c48070a07bcc412ce737a652cacc0cf79b8e12f382d7c2ff5be73eab81fe"
    sha256               x86_64_linux:   "73b8a305ad9eb561d24d517f30fe996c2bfe81aca4a0d5384ca3e0da7b98fcf3"
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
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.4.0/title-sequences.zip"
    sha256 "6e7c7b554717072bfc7acb96fd0101dc8e7f0ea0ea316367a05c2e92950c9029"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/archive/v1.2.7.tar.gz"
    sha256 "ec9a4f862365477b24a9eea16159131b235e05330fa2becefa1a113b17e6bceb"
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
