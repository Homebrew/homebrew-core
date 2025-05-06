class Qemu < Formula
  desc "Generic machine emulator and virtualizer"
  homepage "https://www.qemu.org/"
  license "GPL-2.0-only"
  head "https://gitlab.com/qemu-project/qemu.git", branch: "master"

  stable do
    url "https://download.qemu.org/qemu-10.0.0.tar.xz"
    sha256 "22c075601fdcf8c7b2671a839ebdcef1d4f2973eb6735254fd2e1bd0f30b3896"

    # The next four patches fix segmentation faults on macOS 15.0-15.3
    # See https://github.com/Homebrew/homebrew-core/issues/221154
    # Changes already merged upstream, remove on next release

    patch do
      url "https://gitlab.com/qemu-project/qemu/-/commit/563cd698dffb977eea0ccfef3b95f6f9786766f3.diff"
      sha256 "51d07db06532bdd655bec3fdd7eb15cd2004fc96652f0d4dc25522917c9b129a"
    end

    patch do
      url "https://gitlab.com/qemu-project/qemu/-/commit/6804b89fb531f5dd49c1e038214c89272383e220.diff"
      sha256 "7e17787f09488fa731d6de8304b689df767236009c19a3bb662904189028d687"
    end

    patch do
      url "https://gitlab.com/qemu-project/qemu/-/commit/797150d69d2edba8b1bd4a7d8c7ba2df1219c503.diff"
      sha256 "82f14935f588f7ee103e2ba25852aa3cbf19a4319588f270e09d3bd33fe83001"
    end

    patch do
      url "https://gitlab.com/qemu-project/qemu/-/commit/a5b30be534538dc6e44a68ce9734e45dd08f52ec.diff"
      sha256 "a1ff1e8e7c64e7f7dfe7284277f2bef76b837a4c3a86394dd29768d1b1586818"
    end
  end

  livecheck do
    url "https://www.qemu.org/download/"
    regex(/href=.*?qemu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "7231d454bb9f7fd7cfeff99727552963c3e8e3fba527a081497e6f3d4540d308"
    sha256 arm64_sonoma:  "aef31f95edeedeb93fd423a9baf655e532869cdeec46e206662a0a4f7370b285"
    sha256 arm64_ventura: "a071c06840012951d7f2103b64ad44dcaa79ab87aeb80429897f1b3114d8a495"
    sha256 sonoma:        "409faa24495d47c4246109b8c10ba9a04e911c5682061cfe5872e8dbe2c2a07c"
    sha256 ventura:       "8edf18802c7b11f88926bc6d6d6de2d09b7c967ad3bd0f678b0b1e7c311d556e"
    sha256 arm64_linux:   "f1fb82f1381011a958406b1c27ae6070e2d042f73c4d3816c402dbb9e8e285d5"
    sha256 x86_64_linux:  "e30368126aeb3ca11ed54502921826fd90a4d15535eb3f8a43d7900655af8ff7"
  end

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build # keep aligned with meson
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

  # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
  # NOTE: Keep outside test block so that `brew fetch` is able to handle slow download/retries
  resource "homebrew-test-image" do
    url "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/official/FD12FLOPPY.zip"
    sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"

    # Remove wheels unless explicitly permitted. Currently this:
    # * removes `meson` so that brew `meson` is always used
    # * keeps `pycotap` which is a pure-python "none-any" wheel (allowed in homebrew/core)
    rm(Dir["python/wheels/*"] - Dir["python/wheels/pycotap-*-none-any.whl"])

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
    archs = %w[
      aarch64 alpha arm avr hppa i386 loongarch64 m68k microblaze microblazeel mips
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
