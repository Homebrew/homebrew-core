class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.10.tar.gz"
  sha256 "564a117ad8d03bb51e85ff6e94a7c038a763a9b3371f58bc55b9b66cc4531050"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "59c299bc563a133043a4e50c8778c86f7c5e6207e5be15ae88af626a5e9e2162"
    sha256 arm64_big_sur:  "8dba5bf35c76919d8446e0c15936895019cf1fda60854864f276cdfa5faa72da"
    sha256 monterey:       "a2ff53046d7e11218f68af115ec97c4f5c861c9cf7397f382327ae9cc88d7bef"
    sha256 big_sur:        "1609e3deedc8229abc07c9d2278a02b548cfcb58a4a2faac3f529c7705798c5d"
    sha256 catalina:       "ab137be97c60c40a6943a8db2cd284434c0d1721881699736a2ab68a617b33f7"
    sha256 x86_64_linux:   "da53b76a45e72eee552530c9796bb7c44251aa454bfcdc24fd975ce5dbc98a45"
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
