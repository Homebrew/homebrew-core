class Qemu < Formula
  desc "Generic machine emulator and virtualizer"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-11.0.0.tar.xz"
  sha256 "c04ca36012653f32d11c674d370cf52a710e7d3f18c2d8b63e4932052a4854d6"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://gitlab.com/qemu-project/qemu.git", branch: "master"

  livecheck do
    url "https://www.qemu.org/download/"
    regex(/href=.*?qemu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a1a3f3bec0d8bbc6976822f8b38758486430809ceb1b6b8d9d98dacb8b961a3b"
    sha256 arm64_sequoia: "469b7fe45e19e5c0516c5369bcba23890412f3e2c243f72690ac65fcb382fe67"
    sha256 arm64_sonoma:  "0d80c35b4760cd5ba1da1c08c6a89511b6c31fba7d9b52f812d255d30ca6bf6e"
    sha256 sonoma:        "a7bd0dd4d00305921af70c535ebd40f972ce6c9c4670fd3c93532da4de533f34"
    sha256 arm64_linux:   "0a18129011938f3bde7689f42855f6f7b2ecea4eb278ed30341bbe0fb6042f15"
    sha256 x86_64_linux:  "e8e6c18ad6782f533e82858b9e832ca2a05e0d641e1e99ae22e31531248dc489"
  end

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => :build # keep aligned with meson
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
  depends_on "pixman"
  depends_on "snappy"
  depends_on "vde"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "attr"
    depends_on "cairo"
    depends_on "elfutils"
    depends_on "gdk-pixbuf"
    depends_on "gtk+3"
    depends_on "keyutils"
    depends_on "libcap-ng"
    depends_on "libepoxy"
    depends_on "libx11"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "systemd"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"

    # Remove wheels unless explicitly permitted. Currently this:
    # * removes `meson` so that brew `meson` is always used
    # * keeps `pycotap` and `qemu_qmp` which are pure-python "none-any" wheels (allowed in homebrew/core)
    rm(Dir["python/wheels/*"] - Dir["python/wheels/{pycotap,qemu_qmp}-*-none-any.whl"])

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-download
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
    # NOTE: Keep outside test block so that `brew fetch` is able to handle slow download/retries
    resource "homebrew-test-image" do
      url "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/official/FD12FLOPPY.zip"
      sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
    end

    archs = %w[
      aarch64 alpha arm avr hppa i386 loongarch64 m68k microblaze mips
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
