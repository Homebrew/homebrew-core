class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.18.tar.gz"
  sha256 "bcd9afce7b869630f97cfdb713668f0f7dccf69fc6b31db1ca74ac2f63524a8d"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "69c9a533f239193b06146dfe4b0b008626a6388bff4b31347b2ebc31360a7962"
    sha256 arm64_big_sur:  "f0f7fcb57b6f09209431a7dfc8ee92c184a39a22e9e8f99a7d4ce92222b725b0"
    sha256 monterey:       "9a8ceb085dfdcf9b469dfd04df2c8e6ea7ed6f2083606495bc20dc898cf39c54"
    sha256 big_sur:        "85edf07788903707cb4fe5f8573c02018342c799371b4d5469b0f314c35d1578"
    sha256 catalina:       "fdc9cab4c43d028d34e1339812c9803d4db3629c1950460e79215c97d6fbe568"
    sha256 x86_64_linux:   "c28595b79336768b8bbc419b4161fb732263ae416f4c827c4f31797f36db8917"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "help", shell_output("#{bin}/fheroes2 -h 2>&1")
  end
end
