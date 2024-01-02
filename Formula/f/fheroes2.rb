class Fheroes2 < Formula
  desc "fheroes2 is a recreation of Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.0.10.tar.gz"
  sha256 "f0bc60973bbdc3c333563a5f53252d6e3edd4ea8c4f91729e0480ff0e6a403a2"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "4ae055248754ea7cfd5f2ba5abb172902e94cd9991dc779151a6e0c7e4f90255"
    sha256 arm64_ventura:  "179ab463fc52fd87139e54d6b1d504aa1b416e25ed62f1febbabc6ebac3af2a5"
    sha256 arm64_monterey: "4497d19db0de10bb71221e40285f042778f6b07f889b6cdb999948adcf6df44a"
    sha256 sonoma:         "b627a0005b0910d6fe3586b5b9fdca642023331d3f0ece766398e3ace96fe292"
    sha256 ventura:        "320cb4dc4d7d347904e65f69650fd456d6c8584051a79725f01654c1e7e49586"
    sha256 monterey:       "de241fccabe4652eb5a0683a5f761d2b8fa941d6512fb145d3cec6d7f4039f3a"
    sha256 x86_64_linux:   "260b147dd6b2ed7825830fcca85f5c4584490a110a68825de6156d8df52a77b1"
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
