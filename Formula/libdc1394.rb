class Libdc1394 < Formula
  desc "Provides API for IEEE 1394 cameras"
  homepage "https://damien.douxchamps.net/ieee1394/libdc1394/"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/project/libdc1394/libdc1394-2/2.2.2/libdc1394-2.2.2.tar.gz"
    sha256 "ff8744a92ab67a276cfaf23fa504047c20a1ff63262aef69b4f5dbaa56a45059"

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
    sha256 "23454c66192a197c5d645553d557a7b1bce04ffb026bc551c4ffa288708b29ef" => :mojave
    sha256 "5fbe25e047f3735fbc4ff24550099fac2884b5a952bc5326afdb0df038f6d29b" => :high_sierra
    sha256 "22a0a8780a225508d5522f147997622d61a286d9edc39ec751208aa3e603a4fc" => :sierra
    sha256 "8a8a439402bab51e569063363df076ab1220780bc0db4bc45931fb1401a2acb4" => :el_capitan
    sha256 "204ba8144423650855fc083cc2726d3a914eb52d210a6136c9cfcc698a81c816" => :yosemite
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
