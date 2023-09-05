class Qemu < Formula
  desc "Emulator for x86 and PowerPC"
  homepage "https://www.qemu.org/"
  license "GPL-2.0-only"
  revision 3
  head "https://git.qemu.org/git/qemu.git", branch: "master"

  stable do
    url "https://download.qemu.org/qemu-8.1.0.tar.xz"
    sha256 "710c101198e334d4762eef65f649bc43fa8a5dd75303554b8acfec3eb25f0e55"

    patch do
      # "softmmu: Assert data in bounds in iotlb_to_section"
      # Needed for cherry-pick of the next commit "softmmu: Use async_run_on_cpu in tcg_commit".
      url "https://gitlab.com/qemu-project/qemu/-/commit/86e4f93d827d3c1efd00cd8a906e38a2c0f2b5bc.diff"
      sha256 "c7b30eafb40b893d1245af910a684899a1cbcfad9435a782e2c1088e36242533"
    end

    patch do
      # "softmmu: Use async_run_on_cpu in tcg_commit"
      # Needed for running x86_64 VM with TCG and SMP.
      # https://gitlab.com/qemu-project/qemu/-/issues/1864#note_1543993006
      url "https://gitlab.com/qemu-project/qemu/-/commit/0d58c660689f6da1e3feff8a997014003d928b3b.diff"
      sha256 "b0f9f899f269074304d59dedf980fa83296c806f705b16a5164ba4d34aad1382"
    end
  end

  livecheck do
    url "https://www.qemu.org/download/"
    regex(/href=.*?qemu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b2b3fee79154afc750f70332197ecf41bafd88bcd899a584e40d73b5849331f5"
    sha256 arm64_monterey: "28f287543f9a852be6124c4fc44b098a10351012858d31439ae08c283afa376c"
    sha256 arm64_big_sur:  "c0e9985a96f81480ea974755e54bcb4af6a867f9420378a350773bedf22fc845"
    sha256 ventura:        "9b72779ef74ac740b988d46c8cb945b0ec86accc0c83c9fc7f3e238408b8f202"
    sha256 monterey:       "8a0b351a62b804a22bbf6d62b83eb47e1bfaf303939b0a4331d618f21c42ec5e"
    sha256 big_sur:        "8a9381e9a384fdb025275fb9cbb29f61bf0690b5ac56a4ccd48f837938630580"
    sha256 x86_64_linux:   "8c89582a207b015206bd911adbe4d87356da62a3f61eb09c0403a8d57285a5ca"
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

  on_linux do
    depends_on "attr"
    depends_on "gtk+3"
    depends_on "libcap-ng"
  end

  fails_with gcc: "5"

  # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
  resource "homebrew-test-image" do
    url "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/official/FD12FLOPPY.zip"
    sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
  end

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
    expected = build.stable? ? version.to_s : "QEMU Project"
    archs = %w[
      aarch64 alpha arm cris hppa i386 m68k microblaze microblazeel mips
      mips64 mips64el mipsel nios2 or1k ppc ppc64 riscv32 riscv64 rx
      s390x sh4 sh4eb sparc sparc64 tricore x86_64 xtensa xtensaeb
    ]
    archs.each do |guest_arch|
      assert_match expected, shell_output("#{bin}/qemu-system-#{guest_arch} --version")
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
