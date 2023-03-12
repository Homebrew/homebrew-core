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
    sha256 arm64_ventura:  "4f109b15e54ce782de7f78d563157d71c47c0476bd172deb678615a9fcd0927c"
    sha256 arm64_monterey: "822fa6f6031b20d3ffc71ae18042ea33ad7f59d2e0b8072ba02d9fc5be0fa763"
    sha256 arm64_big_sur:  "36ab1c9eaee524bf4db83af7a86e2b96ae4cf899f335b1ba1c0a7cb94f119071"
    sha256 ventura:        "f8cf038351081623efccad7d3a03e8dbd930e3725eb71d80b4a94c09421cb131"
    sha256 monterey:       "979854b758480a67a7c6839b0b2ee565d1a14ce8efb9e3cbf2758a78391bec4f"
    sha256 big_sur:        "072480d670634a6b8fa294c89f33b9800eac9bd24a8d26d23f24235d950d9430"
    sha256 x86_64_linux:   "7b2d3132501e32e4b2c7c09402206c31cda481f17466c5dfd2ddb0b229e439d1"
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
