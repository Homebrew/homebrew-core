class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      :tag      => "v0.2.2",
      :revision => "298c9f5238fe2ead4c319dd0699cdebf9fe390cb"
  head "https://github.com/OpenRCT2/OpenRCT2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "81667f8350335e530b921546cc9cbbc4e18172772b2c8d01db322422a1f65155" => :mojave
    sha256 "e6cb291eb73f91b3616e6e3480e1fdc295add2adf026187f63adc32308110d3d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype" # for sdl2_ttf
  depends_on "icu4c"
  depends_on "jansson"
  depends_on "libpng"
  depends_on "libzip"
  depends_on :macos => :high_sierra # "missing: Threads_FOUND" on Sierra
  depends_on "openssl"
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
