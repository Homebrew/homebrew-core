class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.6.9/bochs-2.6.9.tar.gz"
  sha256 "ee5b677fd9b1b9f484b5aeb4614f43df21993088c0c0571187f93acb0866e98c"
  revision 1

  bottle do
    sha256 "b2e82d738775f2a48b8f77cfc8d327d474f9dcb89adbe14c15c80a93ab557cf2" => :sierra
    sha256 "260f1b38a089d49cf04f9222d1e7fab064a4f97978b7c83fefbfc75785cffa90" => :el_capitan
    sha256 "40de2be3e8bd6c575b8897bf4dc6d44996af9f63c22216546f656e4e29f87806" => :yosemite
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
