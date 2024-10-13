class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.8/bochs-2.8.tar.gz"
  sha256 "a85b13aff7d8411f7a9f356ba6c33b5f5dc1fbb107eb5018cc23a62639da0059"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/bochs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "829ff76b53d139c6e587138fbdbcf4ad8ddc587a42867df4485e8a734019650c"
    sha256 arm64_sonoma:   "cbf7d0822dc3621c522b35dd08f0c6b13229b09cc8486b03714cdc9720c13b8a"
    sha256 arm64_ventura:  "554222dd225e1e45dbbcc66835e725b8e7ee948819bee598332baccda2a74361"
    sha256 arm64_monterey: "863d294eb8184e8c789f1d10d6d317033da4b0e29b975f8fd9e5b04ace9e017d"
    sha256 sonoma:         "fab7abe0dd5d19498de67f51071ff85fd2e4c7b06ed4a19422321412a5bb76a9"
    sha256 ventura:        "b8157f821216b5c7ed9ccc378415f05a5effd7533921b54089c7f3379585c05a"
    sha256 monterey:       "174f8941f3e15e18fce21a3f8dc3933d0e749793cedbe11619a6f23b39c0ee15"
    sha256 x86_64_linux:   "62d0ad82342936b765efec9a5b9a2525d5daf1ebfa86be5d89530a0c585e7969"
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "sdl2"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
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
      [BIOS  ] No bootable device.
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
