class OpenOcd < Formula
  desc "On-chip debugging, in-system programming and boundary-scan testing"
  homepage "https://sourceforge.net/projects/openocd/"
  url "https://downloads.sourceforge.net/project/openocd/openocd/0.10.0/openocd-0.10.0.tar.bz2"
  sha256 "7312e7d680752ac088b8b8f2b5ba3ff0d30e0a78139531847be4b75c101316ae"

  bottle do
    rebuild 1
    sha256 "281978e21362ed00dd198715825d77f0f2aeb64ad99954714a34ce128e1a0df8" => :sierra
    sha256 "e1fc5f8a8bf079954a56459b330313cd82a69a219114821c14f9d3df2fd3ea25" => :el_capitan
    sha256 "568ae702a3488805b8651b5456346c9484ca6f8486a09f3c2a4473664370a481" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/openocd/code.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  option "without-hidapi", "Disable building support for devices using HIDAPI (CMSIS-DAP)"
  option "without-libftdi", "Disable building support for libftdi-based drivers (USB-Blaster, ASIX Presto, OpenJTAG)"
  option "without-libusb",  "Disable building support for all other USB adapters"

  depends_on "pkg-config" => :build
  depends_on "libusb" => :recommended
  # some drivers are still not converted to libusb-1.0
  depends_on "libusb-compat" if build.with? "libusb"
  depends_on "libftdi" => :recommended
  depends_on "hidapi" => :recommended

  def install
    # all the libusb and hidapi-based drivers are auto-enabled when
    # the corresponding libraries are present in the system
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-dummy
      --enable-buspirate
      --enable-jtag_vpi
      --enable-remote-bitbang
    ]

    ENV["CCACHE"] = "none"

    system "./bootstrap", "nosubmodule" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
