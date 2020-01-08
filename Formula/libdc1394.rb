class Libdc1394 < Formula
  desc "Provides API for IEEE 1394 cameras"
  homepage "https://damien.douxchamps.net/ieee1394/libdc1394/"

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
  end

  bottle do
    cellar :any
    sha256 "57080908a5da9abb2c0d83d4ad25450a507de8140a812112d9e5751f4004e4d0" => :catalina
    sha256 "6cf02c5500f83fa2ccd1ff9b880f44f9652d68b0e90a2345d6c62fb92a988f0a" => :mojave
    sha256 "536cbd34a43886d63a3dba41e7877ed63ad0fbe1a5e21cde499bd2c9e1e37e52" => :high_sierra
    sha256 "ff1d7c6b07f21d8cd485574b10091eb21c2316390a7d4cfa84d29cccce8097e6" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/libdc1394/code.git"
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
