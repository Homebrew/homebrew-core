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
    rebuild 1
    sha256 "03c936f6b09101d9df8c5781ea638f68b022883740b352f656c07046b6f2e085" => :sierra
    sha256 "aca2dc5c08f1e56d834f814d63edf32e0af86f0fa27e6fdd2df2f247179cf96f" => :el_capitan
    sha256 "7ae3e7c4217d0c76b2caa3c961480d646ed0a50fabde1567cb6f10c1b2f08e18" => :yosemite
    sha256 "c5036e695691464ce2f5b6b957b08f77b8ec436475c9eb8948305f26da81af48" => :mavericks
    sha256 "989b8f20b2ad01c6c3d607fe974c3cf5ad005b51afa8455ec712325c8d4d5b22" => :mountain_lion
  end

  head do
    url "https://git.code.sf.net/p/libdc1394/code.git"
    depends_on "libusb"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
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
