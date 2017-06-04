class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.6.9/bochs-2.6.9.tar.gz"
  sha256 "ee5b677fd9b1b9f484b5aeb4614f43df21993088c0c0571187f93acb0866e98c"
  revision 1

  bottle do
    sha256 "8dd191ff5085b435ff26cd53026d8afada7fa9e18d84a985da2a6a9d6b179a64" => :sierra
    sha256 "395ce5d3047ee0b98c8eb2130a8661d319a0926c19e7ebf6b31fc01dee0e8edf" => :el_capitan
    sha256 "b32844f457ead67e1a656a1a6d05c0a67d56cc1b68d0ffb60f86d3c8ec0f50cf" => :yosemite
  end

  option "with-gdb-stub", "Enable GDB Stub"
  option "without-sdl2", "Disable graphical support"

  depends_on "pkg-config" => :build
  depends_on "sdl2" => :recommended

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
      --enable-show-ips
      --enable-logging
      --enable-usb
      --enable-cpu-level=6
      --enable-clgd54xx
      --enable-avx
      --enable-vmx=2
      --enable-smp
      --enable-long-phy-addres
      --with-term
    ]

    args << "--with-sdl2" if build.with? "sdl2"

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
    require "open3"

    (testpath/"bochsrc.txt").write <<-EOS.undent
        panic: action=fatal
        error: action=report
        info: action=ignore
        debug: action=ignore
        display_library: nogui
      EOS

    expected = <<-ERR.undent
        Bochs is exiting with the following message:
        \[BIOS  \] No bootable device\.
      ERR

    command = "#{bin}/bochs -qf bochsrc.txt"
    if build.without? "gdb-stub"
      # When the debugger is enabled, bochs will stop on a breakpoint early
      # during boot. We can pass in a command file to continue when it is hit.
      (testpath/"debugger.txt").write("c\n")
      command << " -rc debugger.txt"
    end

    _, stderr, = Open3.capture3(command)
    assert_match(expected, stderr)
  end
end
