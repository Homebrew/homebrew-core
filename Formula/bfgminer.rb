class Bfgminer < Formula
  desc "Modular CPU/GPU/ASIC/FPGA miner written in C"
  homepage "http://bfgminer.org"
  url "http://bfgminer.org/files/latest/bfgminer-5.5.0.txz"
  sha256 "ac254da9a40db375cb25cacdd2f84f95ffd7f442e31d2b9a7f357a48d32cc681"
  license "GPL-3.0-or-later"
  head "https://github.com/luke-jr/bfgminer.git", branch: "bfgminer"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "hidapi" => :build
  depends_on "libgcrypt" => :build
  depends_on "libscrypt" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "uthash" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "libusb"

  on_linux do
    depends_on "curl" => :build
  end

  def install
    libgcrypt = Formula["libgcrypt"]
    libusb = Formula["libusb"]

    configure_args = ["CPPFLAGS=-I#{libgcrypt.opt_include} -I#{libusb.opt_include}/libsub-1.0"]
    configure_args << "LDFLAGS=-L#{libgcrypt.opt_lib} -L#{libusb.opt_lib}"
    configure_args << "--with-udevrulesdir=#{lib}/udev" if OS.linux?
    configure_args << "--without-system-libbase58"
    configure_args << "--enable-cpumining"
    configure_args << "--enable-opencl"
    configure_args << "--enable-scrypt"
    configure_args << "--enable-keccak"
    configure_args << "--enable-bitmain"
    configure_args << "--enable-alchemist"

    system "./configure", *std_configure_args, *configure_args
    system "make", "install"
  end

  test do
    assert_match "Work items generated", shell_output("#{bin}/bfgminer --benchmark 2>/dev/null <<< q")
  end
end
