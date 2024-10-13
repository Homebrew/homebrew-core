class Qemu < Formula
  desc "Generic machine emulator and virtualizer"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-9.1.0.tar.xz"
  sha256 "816b7022a8ba7c2ac30e2e0cf973e826f6bcc8505339603212c5ede8e94d7834"
  license "GPL-2.0-only"
  head "https://gitlab.com/qemu-project/qemu.git", branch: "master"

  livecheck do
    url "https://www.qemu.org/download/"
    regex(/href=.*?qemu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "dece9fbfe1459299e50c0cd889de8f5d19e8bb4cf13fd8fd76120bfe83987fc8"
    sha256 arm64_sonoma:   "38dd1e6661be138fdba4dfcd4a05ab944e7ed71bb3746d33f3a6716c561fdeee"
    sha256 arm64_ventura:  "c882674e88f68ae585bda60e3d62b86e1ca5ec81ab09aca986e9d8e4bfb19773"
    sha256 arm64_monterey: "6061552f62a6a0442230a9db2fccfcfd776258b3124dc3af7ab848d24b846cf7"
    sha256 sonoma:         "64703d275dea566cac98289605145f824daeca4be77cef38b65d666a539ff48f"
    sha256 ventura:        "16d1e1f7e8b1faff279e7aaeb9fd867edd71f5bbfedc866ded4f72c7cd8eaad7"
    sha256 monterey:       "a08143d022b54749de2d11008f412b3e04a0181606ab281ab6381d29ad39b68b"
    sha256 x86_64_linux:   "4bb6c665f57c8cd91eba85835efb99684afc271f002d606d4879c1027ecd3aed"
  end

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "spice-protocol" => :build

  depends_on "capstone"
  depends_on "dtc"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "snappy"
  depends_on "vde"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "attr"
    depends_on "cairo"
    depends_on "elfutils"
    depends_on "gdk-pixbuf"
    depends_on "gtk+3"
    depends_on "libcap-ng"
    depends_on "libepoxy"
    depends_on "libx11"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "systemd"
  end

  fails_with gcc: "5"

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
      --enable-slirp
      --enable-capstone
      --enable-curses
      --enable-fdt=system
      --enable-libssh
      --enable-vde
      --enable-virtfs
      --enable-zstd
      --extra-cflags=-DNCURSES_WIDECHAR=1
      --disable-sdl
    ]

    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

    args += if OS.mac?
      ["--disable-gtk", "--enable-cocoa"]
    else
      ["--enable-gtk"]
    end

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
    resource "homebrew-test-image" do
      url "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/official/FD12FLOPPY.zip"
      sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
    end

    archs = %w[
      aarch64 alpha arm avr cris hppa i386 loongarch64 m68k microblaze microblazeel mips
      mips64 mips64el mipsel or1k ppc ppc64 riscv32 riscv64 rx
      s390x sh4 sh4eb sparc sparc64 tricore x86_64 xtensa xtensaeb
    ]
    archs.each do |guest_arch|
      assert_match version.to_s, shell_output("#{bin}/qemu-system-#{guest_arch} --version")
    end

    resource("homebrew-test-image").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info FLOPPY.img")

    # On macOS, verify that we haven't clobbered the signature on the qemu-system-x86_64 binary
    if OS.mac?
      output = shell_output("codesign --verify --verbose #{bin}/qemu-system-x86_64 2>&1")
      assert_match "valid on disk", output
      assert_match "satisfies its Designated Requirement", output
    end
  end
end
