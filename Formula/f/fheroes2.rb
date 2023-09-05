class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/1.0.7.tar.gz"
  sha256 "f6bb254ddd848c6a65ed7cd6863c755482c28879e3a97f0b1f5421d939c9626f"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "ddf743a62c4f4530d65ec42ab5fcde2d42a025a425aa02b3f9da4ab5309867dc"
    sha256 arm64_monterey: "ffe9a6d485d3da80ee85215df941c19722b2ae1b21bad754c031c47eceeb386b"
    sha256 arm64_big_sur:  "ef7c83f54868580eedb6416d4441a220371fdfd18dce1481e1554de2ad1c3c8c"
    sha256 ventura:        "7cb8146c616ab0948f8d4771eb77de71bf4105bff9c1cc7345511ba2f2bc55aa"
    sha256 monterey:       "fd50b303913be8c09876e07159fa646fe81bdf26768773baebe8f58f6ccfa1e7"
    sha256 big_sur:        "c2bc52997eea567cfa5332b05fc83480d75a776a625d15dd190addce827011ca"
    sha256 x86_64_linux:   "0358f3375f893dded5e96b870679370eebd48d59a245287fffbe21b997b9ca6a"
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
