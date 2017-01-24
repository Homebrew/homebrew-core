class OpenOcd < Formula
  desc "On-chip debugging, in-system programming and boundary-scan testing"
  homepage "https://sourceforge.net/projects/openocd/"
  url "https://downloads.sourceforge.net/project/openocd/openocd/0.10.0/openocd-0.10.0.tar.bz2"
  sha256 "7312e7d680752ac088b8b8f2b5ba3ff0d30e0a78139531847be4b75c101316ae"

  bottle do
    sha256 "ac70011a3b3a5a71841caa561d3e9944611746bc237a557edfe2d5ec701350ed" => :sierra
    sha256 "05e9d52c24ade1b279881424463b170697221d8c54f389192ef3225d7b7f6fd5" => :el_capitan
    sha256 "330f77cc10f96e959f977cfce2b62bf36416f3032f7e30638c58b1237bc829bd" => :yosemite
  end

  head do
    url "git://git.code.sf.net/p/openocd/code"

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
