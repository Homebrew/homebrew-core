class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-3/dosbox-0.74-3.tar.gz"
  sha256 "c0d13dd7ed2ed363b68de615475781e891cd582e8162b5c3669137502222260a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "1e4665781d74eb8d4b6c06c0342adc7b070a06878de16b5871d7c38dfdf1d9b1"
    sha256 cellar: :any,                 arm64_ventura:  "68a487d11fa60605b0c558718b5a03d55c299e7630237071271a4747c41f74d7"
    sha256 cellar: :any,                 arm64_monterey: "3dd3bc00e4f462681f1fdbe36d0e6a0e9304c0af255921f81b725645939c1033"
    sha256 cellar: :any,                 arm64_big_sur:  "7915a1fd2252960d61b3f7f0afdec0a0dd2fc3b3e94bed387b80042df9fa6fa2"
    sha256 cellar: :any,                 sonoma:         "44a66467cfa7e97a64fe159cf67c7efbe50c862eebdab7765d339221654f1176"
    sha256 cellar: :any,                 ventura:        "5ba4fa87bf0f348c34010b58704c0deed4f46343d1741478adb3c419c07bc26e"
    sha256 cellar: :any,                 monterey:       "76e4d2f92b5a26c3adef2f93f8b888ca28dded281c19fec4e2d8b98846442974"
    sha256 cellar: :any,                 big_sur:        "e30428b22f27e51a3f09db39a743ce9244488b12969c8dbd6d7e0306cffa2ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6395e97359209de3a67567107030c99d2a1fd23c2a1fadf99c562ba6d9623ca"
  end

  head do
    url "https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  # Has dependencies on deprecated `sdl_net` and `sdl_sound`.
  # Recommend available forks that support SDL 2 or the Cask (macOS-only).
  disable! date:    "2024-02-16",
           because: "uses deprecated SDL 1.2. Consider `dosbox-x`/`dosbox-staging` formulae or `dosbox` cask"

  depends_on "libpng"
  depends_on "sdl12-compat"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"dosbox", "-version"
  end
end
