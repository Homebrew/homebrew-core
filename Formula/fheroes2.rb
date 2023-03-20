class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/1.0.2.tar.gz"
  sha256 "f4f85ef4b46af354abef11e813ed10d8360498620514ff9809a3844bdca52238"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "4ac59e54475f3942b278be1dd8ca38faf40fb5d9168e72e17f89cf44ba8f70c6"
    sha256 arm64_monterey: "3f47cb3d7098cdd8fc64dcf99e12482394712d383d60f08d4d5a44a6b4a5f363"
    sha256 arm64_big_sur:  "7495fdcc469a855706d8e2a926b7496006967783009ba0965b12ecefea147936"
    sha256 ventura:        "113af4b99eb08d282e1d7e9aebb37678c8fa7c169892aa31b745f73b92e44b70"
    sha256 monterey:       "a2a4e82e9f4778f76bc964d39a0e025af30e2ad50c1e3c23e98ce892e0709989"
    sha256 big_sur:        "1ad804242f6bab86d297d120140e403a224bc07c3d6bdf011a1275cf2a08c8e6"
    sha256 x86_64_linux:   "163bdf6ac2779f72f7faa328375dbda6671fb0163aea99d6ef10ca193ced5ec1"
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
