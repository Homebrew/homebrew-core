class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/1.0.8.tar.gz"
  sha256 "44047c787597a2b4a1f57f6189c9c7b0248729932327aa0a7973b55e9889ae87"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "a20a19a84a697602a3ec95e349c516cbce5f2f7f33ef36d9ffae08b28df8c860"
    sha256 arm64_monterey: "7eb214c8e971b24bcc523b6c46be6d4b20e648fc57ef5fe7c6dafd543cbc15ee"
    sha256 arm64_big_sur:  "dff372935b5db6df5462e0c7615f045e10fc7c006843502a98411c0fdb8e268a"
    sha256 ventura:        "bbbf64733b9bfd17ee966d37ce327c2548e57e2c85fba15b23c30b5e6c7459b7"
    sha256 monterey:       "b19661be09880839fbb664e3d17bbff376fdff7c6b5b35556286bd7e054cbebc"
    sha256 big_sur:        "6b3864d5ba521bc1ece7480dd06f90761bc126c66e29edade9f6241e7e369631"
    sha256 x86_64_linux:   "ef5cbe653a931d360e8e4a00d79fcd2a113004e29609af29f76356432389051b"
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
