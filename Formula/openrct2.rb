class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.3.2",
      revision: "cea5fab238e5dd17a2f958c0a484ad97035264ae"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    cellar :any
    sha256 "109a8f7a28f2f13a23a4bf42ac84438db7f624fbdd2f1ed757580e6f8663fcb3" => :big_sur
    sha256 "273826beee0425dc36e3c3cc039ae0a15992b1cc02032066cc4a72226f995347" => :arm64_big_sur
    sha256 "dad7b09f8b99e6fc19cc50a7d83d752b7245d869df90006e4eac2cde76ff6e11" => :catalina
    sha256 "d1e3f34d2bf5cde75033a84b04962ad2947622e7f845146a2c85b72cc3ae0179" => :mojave
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
    url "https://github.com/OpenRCT2/objects/releases/download/v1.0.17/objects.zip"
    sha256 "bc31ca8ca56f40f9ff7958416611bc712932c1eda80ca94861789aa57da1740e"
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
      exec "#{libexec}/openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
