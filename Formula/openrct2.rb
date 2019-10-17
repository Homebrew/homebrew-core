class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      :tag      => "v0.2.3",
      :revision => "ac7a1ebf71566afb093befcb8293406c1a4025b4"
  revision 1
  head "https://github.com/OpenRCT2/OpenRCT2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "d530848a852d70ba5aeb3835d3fc26d2d7de17d467b4299a4f5147549107e8e0" => :catalina
    sha256 "20b9a691444ad32d3f501188e1202ad4213236470e9fd17c2dc1775bf52dec37" => :mojave
    sha256 "87841d042bf53166e2fc275178fa2c781d557e1473a0723b81f67040442e478f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype" # for sdl2_ttf
  depends_on "icu4c"
  depends_on "jansson"
  depends_on "libpng"
  depends_on "libzip"
  depends_on :macos => :high_sierra # "missing: Threads_FOUND" on Sierra
  depends_on "openssl@1.1"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "speexdsp"

  resource "title-sequences" do
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.1.2a/title-sequence-v0.1.2a.zip"
    sha256 "7536dbd7c8b91554306e5823128f6bb7e94862175ef09d366d25e4bce573d155"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/releases/download/v1.0.10/objects.zip"
    sha256 "4f261964f1c01a04b7600d3d082fb4d3d9ec0d543c4eb66a819eb2ad01417aa0"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/title").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    # By default macOS build only looks up data in app bundle Resources
    libexec.install bin/"openrct2"
    (bin/"openrct2").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
