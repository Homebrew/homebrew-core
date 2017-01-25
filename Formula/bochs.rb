class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "http://bochs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.6.8/bochs-2.6.8.tar.gz"
  sha256 "79700ef0914a0973f62d9908ff700ef7def62d4a28ed5de418ef61f3576585ce"

  option "with-gdb-stub", "Enable GDB Stub"

  depends_on "pkg-config" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --with-nogui
      --enable-disasm
      --disable-docbook
      --enable-x86-64
      --enable-pci
      --enable-all-optimizations
      --enable-plugins
      --enable-cdrom
      --enable-a20-pin
      --enable-fpu
      --enable-alignment-check
      --enable-large-ramfile
      --enable-debugger-gui
      --enable-readline
      --enable-iodebug
      --enable-xpm
      --enable-show-ips
      --enable-logging
      --enable-usb
      --enable-ne2000
      --enable-cpu-level=6
      --enable-sb16
      --enable-clgd54xx
      --with-term
    ]

    if build.with? "gdb-stub"
      args << "--enable-gdb-stub"
    else
      args << "--enable-debugger"
    end

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    system bin/"bochs", "--help"
  end
end
