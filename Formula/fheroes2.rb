class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/1.0.3.tar.gz"
  sha256 "b6f0b838ca630a0fe4768e1d819eeb77fce2d6cf083760e33749c95cb4545b41"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "43d3ea355281157e9861aef55a81fbb06fe970260773cff179e945bb1d008704"
    sha256 arm64_monterey: "53f357d222c7dbec77a3bf3d222d5302892dcee749d3254bafe697039c0c66f8"
    sha256 arm64_big_sur:  "c0650c75f822dec4fb0f6b4bd1d3584c545c7cce9f917e5132c396d363e5f28a"
    sha256 ventura:        "ff496d3e71c5153c98f34c65ccefe5ccd0768f11ec55ff898da738e640f3abea"
    sha256 monterey:       "7c355443a3e31fa44179425d3fdbe5814613fe91524d2ceed0530de64e9e5fb5"
    sha256 big_sur:        "8fb01da389ba2081568e727a3d4261a7cff52f1de223815f23cd53fdb3c23332"
    sha256 x86_64_linux:   "94b15208e7f8b9b86429bc6b822091c8b64462f5bcb50f53538e3c98507b2516"
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
