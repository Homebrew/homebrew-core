class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.6.9/bochs-2.6.9.tar.gz"
  sha256 "ee5b677fd9b1b9f484b5aeb4614f43df21993088c0c0571187f93acb0866e98c"
  revision 2

  bottle do
    sha256 "92cfa3291e3e8733d0902aaf5f2bcd3bb08c2649e2d305545eaa325e75c40755" => :mojave
    sha256 "6704008062d55a66ca8a8ab359db801f806f5e40b18a2ae2af18ac76353ea187" => :high_sierra
    sha256 "f866b444fc8dd6c31a5104d8f6115720bd0e0ee46775d92a4258f68ccea214ce" => :sierra
    sha256 "d7c0d5ee817ba9f3c596ab6364c62b0160c74aefce2db1033438cb17978a8291" => :el_capitan
  end

  option "with-gdb-stub", "Enable GDB Stub"
  option "without-sdl2", "Disable graphical support"

  depends_on "pkg-config" => :build
  depends_on "sdl2" => :recommended

  # Fix pointer cast issue
  # https://sourceforge.net/p/bochs/patches/537/
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e9b520dd4c/bochs/xcode9.patch"
      sha256 "373c670083a3e96f4012cfe7356d8b3584e2f0d10196b4294d56670124f5e5e7"
    end
  end

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
      --enable-long-phy-address
      --with-term
    ]

    args << "--with-sdl2" if build.with? "sdl2"

    if build.with? "gdb-stub"
      args << "--enable-gdb-stub"
    else
      args << "--enable-debugger"
      args << "--enable-smp"
    end

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    require "open3"

    (testpath/"bochsrc.txt").write <<~EOS
      panic: action=fatal
      error: action=report
      info: action=ignore
      debug: action=ignore
      display_library: nogui
    EOS

    expected = <<~EOS
      Bochs is exiting with the following message:
      \[BIOS  \] No bootable device\.
    EOS

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
