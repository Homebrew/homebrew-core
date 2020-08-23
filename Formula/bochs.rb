class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.6.11/bochs-2.6.11.tar.gz"
  sha256 "63897b41fbbbdfb1c492d3c4dee1edb4224282a07bbdf442a4a68c19bcc18862"

  bottle do
    sha256 "b6d43a6a60360e0d84ebd2ad9ae7724c413a1f2332c59065fb09c2004d76b723" => :catalina
    sha256 "74fb37178645c4d2b52eec5684931ca215dc2f75794e1cf45b3f6e2b85263819" => :mojave
    sha256 "f8c79923292849eebece21d9c5ed1028db729d4d25dc1e045a7c8e0f0dcf450b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "sdl2"

  uses_from_macos "ncurses"

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
      --disable-docbook
      --enable-a20-pin
      --enable-alignment-check
      --enable-all-optimizations
      --enable-avx
      --enable-evex
      --enable-cdrom
      --enable-clgd54xx
      --enable-cpu-level=6
      --enable-debugger
      --enable-debugger-gui
      --enable-disasm
      --enable-fpu
      --enable-iodebug
      --enable-large-ramfile
      --enable-logging
      --enable-long-phy-address
      --enable-pci
      --enable-plugins
      --enable-readline
      --enable-show-ips
      --enable-usb
      --enable-vmx=2
      --enable-x86-64
      --with-nogui
      --with-sdl2
      --with-term
    ]

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

    # When the debugger is enabled, bochs will stop on a breakpoint early
    # during boot. We can pass in a command file to continue when it is hit.
    (testpath/"debugger.txt").write("c\n")
    command << " -rc debugger.txt"

    _, stderr, = Open3.capture3(command)
    assert_match(expected, stderr)
  end
end
