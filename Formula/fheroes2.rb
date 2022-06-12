class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.16.tar.gz"
  sha256 "43288a2b5714d5b5704704ca22d7fd32391271316d217d49e235dee202042cc3"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "b28fa3abd45ce66e15c65dc74effc24243ea5daa722b2b976e3fb490d96cc1dd"
    sha256 arm64_big_sur:  "8adfa7329fdc1ee334c26f43ac0b6b98d56e5d26970683a3c257e84123f9ff7c"
    sha256 monterey:       "de56917b8a156dc35d9d851feed7294e1c73b5fc0e8df13c9384b867b4435fac"
    sha256 big_sur:        "a4d09914a168010dde809b858714596ed596a0e2b24b169ee7f0c93945f57e17"
    sha256 catalina:       "7d58b867efd381b1cf953202b2727771802e2452c696892cb47f6c92e6c3d297"
    sha256 x86_64_linux:   "b700110290beb1fd28eaa38c7aee4cab1bf121769b823d540d494553828bd599"
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
