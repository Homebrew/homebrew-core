class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/1.0.5.tar.gz"
  sha256 "53d889bb712cede9ad85d9fbaa09338b06c6948b247221464dd5b767a95f12c6"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "640301fc4ffc3f9ef2aeca26a5c9e1eedc2eae2c0a8a5d0416ca95d2f446b353"
    sha256 arm64_monterey: "fcd59ca7fafebdb6ac444a2e2ecb3730879b0cd3a794c24fd0738b16330b4cd1"
    sha256 arm64_big_sur:  "397701fc129bd3451c9ebc1a3449a706e43e0955c362a298894f998cfe66cab8"
    sha256 ventura:        "e7271c694e4bd19dbcf93652240fd88bef7ecc08763baed932194a7c7b159082"
    sha256 monterey:       "3c1948644a852022d5bf7ada717cf2839100f9189ee8a52fc6d31d25ef97af94"
    sha256 big_sur:        "a0699bc4f08682394924417f0d3f759ceed240172faf1914ce43a35dde2fc485"
    sha256 x86_64_linux:   "bcc07b953a708fe05888bf7ef5345bed572ccaabfc631eb77283a04bd166dc20"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
    bin.install "script/homm2/extract_homm2_resources.sh" => "fheroes2-extract-resources"
  end

  def caveats
    <<~EOS
      Documentation is available at:
      #{share}/doc/fheroes2/README.txt
    EOS
  end

  test do
    io = IO.popen("#{bin}/fheroes2 2>&1")
    io.any? do |line|
      line.include?("fheroes2 engine, version:")
    end
  end
end
