class Fheroes2 < Formula
  desc "Recreation of the Heroes of Might and Magic II game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/refs/tags/1.1.1.tar.gz"
  sha256 "3b5df5aa26d11615fcc15d626d77832f730e24fbab7d419539c4236df5a94c5e"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e45bd46df9a2c6c77b49bff537bcf6cd10abb618606071a1b9d6a78d727f26db"
    sha256 arm64_ventura:  "68c213461ba7b741f813dd5cb1a3b135ade62c372df46a4e90b9833d3bd8be2d"
    sha256 arm64_monterey: "c134e447813b02f0d6bdde194721c1044e1dc8da332179139dfbf581bd4fb23b"
    sha256 sonoma:         "94deb9225c19aebcbdf203c66a0cffe39cc0aa41e4fa61e4cd39674d5b119287"
    sha256 ventura:        "af81c697463ca0a480b931c21c4736cb8db94b9831ed788aa16ba2e1fcd249b3"
    sha256 monterey:       "65246772afded808b1b0d9537cab2cfe0f407531785d1e56f7df1e9c2b564d6a"
    sha256 x86_64_linux:   "ea430fb4056e17e337da8c8049d2abc1e31886817842d111bb5a7888415049ce"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "innoextract"
  depends_on "sdl2"
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
