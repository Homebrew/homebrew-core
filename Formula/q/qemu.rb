class Qemu < Formula
  desc "Generic machine emulator and virtualizer"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-11.0.2.tar.xz"
  sha256 "3745f6ea88e2e87fe0dc838b2b1d4e0a770bf48e01a1d5a186842a1fff76ccf5"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://gitlab.com/qemu-project/qemu.git", branch: "master"

  livecheck do
    url "https://www.qemu.org/download/"
    regex(/href=.*?qemu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "61dcaa97f0f1351e64020abbcb1d48bb19a1836f8e1014186adde9758385e261"
    sha256 arm64_sequoia: "2d516a6efc561e9726af2f47ae508a834cca8210b92b90eaafd4b53b62c8c3f7"
    sha256 arm64_sonoma:  "e044b5a9aa2e3e64c480a31b7af9725308d9932c341828a61a6b7c6830dc1f1e"
    sha256 sonoma:        "ee18d10813d8c89bd4da62a34ef86eaeccc3cf55653a31ce2d6427947940dd26"
    sha256 arm64_linux:   "252e8f9e5a5351ffe3a58873c57858b09ded07a79ad18e83b288a3f8db8b9cd1"
    sha256 x86_64_linux:  "3b05f00f89fa4060bac3476ee50ace9ac56e0556c7be757cfa733d1da895a9b4"
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
