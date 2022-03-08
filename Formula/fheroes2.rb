class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.13.tar.gz"
  sha256 "f46479783511d2c244778e558a624db164102cedb6116419fed97ec862f9505d"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "f5e724ca4b140ea066c7c109f292e747df0d81833161bfb28077b4d1074d2c7a"
    sha256 arm64_big_sur:  "8f0fc8030c58fd6033cca535a9d3ead3df81c966bfe87d017b0c945632dc8532"
    sha256 monterey:       "c9f05ba7d077eedaf76b86690296c6ac1c31bf56e9e0acb08ee56455b83d9c29"
    sha256 big_sur:        "567db3c66181f34d846d8a6a2aa2b8a52779a0eebcfbb221b6e587fe65f8f110"
    sha256 catalina:       "ca570648ec27195dec25a33ba30c24efd3ce09220dd7523827d274a10c74cb96"
    sha256 x86_64_linux:   "f175bb8ede34364fc656cdc5af301c28540690e3be7995dfec0148e7ec5e3242"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "make", "-C", "files/lang"

    (pkgshare/"files/lang").install Dir["files/lang/*.mo"]
    pkgshare.install "fheroes2.key"
    bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
  end

  test do
    assert_match "help", shell_output("#{bin}/fheroes2 -h 2>&1")
  end
end
