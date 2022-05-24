class Libdc1394 < Formula
  desc "Provides API for IEEE 1394 cameras"
  homepage "https://damien.douxchamps.net/ieee1394/libdc1394/"
  license "LGPL-2.1"

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
    sha256 cellar: :any,                 arm64_monterey: "7d749b90fc87178b9f168bd129f204e4668758e09beda52b6a9cd2e7c680557c"
    sha256 cellar: :any,                 arm64_big_sur:  "8af168268139e714a725ab1d4384a34ef092a3e50e081baba66fdf583fef3711"
    sha256 cellar: :any,                 monterey:       "f838aec8a1a70d8e69dde3fee3e93b8869e821aafad8a5e7fcd2c3739cb0a53b"
    sha256 cellar: :any,                 big_sur:        "7eef59a97b33666b144d68181b081eba93c4c23c58f159a67684d2ed2d043080"
    sha256 cellar: :any,                 catalina:       "57080908a5da9abb2c0d83d4ad25450a507de8140a812112d9e5751f4004e4d0"
    sha256 cellar: :any,                 mojave:         "6cf02c5500f83fa2ccd1ff9b880f44f9652d68b0e90a2345d6c62fb92a988f0a"
    sha256 cellar: :any,                 high_sierra:    "536cbd34a43886d63a3dba41e7877ed63ad0fbe1a5e21cde499bd2c9e1e37e52"
    sha256 cellar: :any,                 sierra:         "ff1d7c6b07f21d8cd485574b10091eb21c2316390a7d4cfa84d29cccce8097e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c95c1747f8a7b05bb423f16a0a2fa2106e6b1413e7424f2fee4a2ed07a92f54a"
  end

  head do
    url "https://git.code.sf.net/p/libdc1394/code.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  depends_on "sdl"

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
