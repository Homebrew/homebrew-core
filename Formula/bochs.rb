class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.7/bochs-2.7.tar.gz"
  sha256 "a010ab1bfdc72ac5a08d2e2412cd471c0febd66af1d9349bc0d796879de5b17a"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/bochs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "e148150828ea9d230cf350212dc8d415e3442ff04e285f4cdc358d0477d282b6"
    sha256 arm64_big_sur:  "413baabcb17f8a7da9b41306215280ef7fe9e898477c31eed66f483cfb15475a"
    sha256 monterey:       "7846c1280fc53365233026350c900bbc481de62b54bce1f454441331e82ce597"
    sha256 big_sur:        "6e644ff1b857016a22941d01d7136a94c39a790dd6ce0f358da5b5b5ab14af78"
    sha256 catalina:       "a903d4549d08e804de103c69866708ac5a993f7a4006687e9465e67991494cb4"
    sha256 mojave:         "8428e13cd552af48b539231826a222f4b74801688aa0e74c2de40c201cb68e30"
    sha256 x86_64_linux:   "e681cbd2cb984ea659bad90239ba755b4fca333be1a4831513b53f461974a98b"
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "sdl2"

  uses_from_macos "ncurses"

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
