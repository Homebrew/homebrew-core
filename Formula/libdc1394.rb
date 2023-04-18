class Libdc1394 < Formula
  desc "Provides API for IEEE 1394 cameras"
  homepage "https://damien.douxchamps.net/ieee1394/libdc1394/"
  license "LGPL-2.1"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/project/libdc1394/libdc1394-2/2.2.6/libdc1394-2.2.6.tar.gz"
    sha256 "2b905fc9aa4eec6bdcf6a2ae5f5ba021232739f5be047dec8fe8dd6049c10fed"

    # fix issue due to bug in OSX Firewire stack
    # libdc1394 author comments here:
    # https://permalink.gmane.org/gmane.comp.multimedia.libdc1394.devel/517
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b8275aa07f/libdc1394/capture.patch"
      sha256 "6e3675b7fb1711c5d7634a76d723ff25e2f7ae73cd1fbf3c4e49ba8e5dcf6c39"
    end

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9a16dd0bb058c51d700fc93c1cbe13d2b185cfeccd9ff90eb300088fd76f595b"
    sha256 cellar: :any,                 arm64_monterey: "df7e187b4be0fd2c0b1d44ae4affaf06c880d10405b49676c46654f7578c578e"
    sha256 cellar: :any,                 arm64_big_sur:  "1130efff7b225327ca8743b863d808f509c1391afb19692be2b14b01f65fc3bf"
    sha256 cellar: :any,                 ventura:        "0f2463909e7b1e94ace46e3a13125073f1ed0b3126e2787b3840ce0900777497"
    sha256 cellar: :any,                 monterey:       "9a293bb439cf246d321f3a2f3b913a0cabcec397dec51134d6bb5c315949d2d4"
    sha256 cellar: :any,                 big_sur:        "d2783838520007d2620ce7a640dc68e7aaf3c47e9ff857d03404594b0343ddc1"
    sha256 cellar: :any,                 catalina:       "392b2fc67276fabb361f3e9d88878c79baff7b50f8666c63e6b3c58f04af81cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5d8ff3fd2c11d8c8387ec2c1d30d6b93bee3f1d5516c2a9df4d2454ad1842cb"
  end

  head do
    url "https://git.code.sf.net/p/libdc1394/code.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  depends_on "sdl12-compat"

  def install
    Dir.chdir("libdc1394") if build.head?
    system "autoreconf", "-i", "-s" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-examples",
                          "--disable-sdltest"
    system "make", "install"
  end
end
