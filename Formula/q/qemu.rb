class Qemu < Formula
  desc "Emulator for x86 and PowerPC"
  homepage "https://www.qemu.org/"
  license "GPL-2.0-only"
  head "https://git.qemu.org/git/qemu.git", branch: "master"

  stable do
    url "https://download.qemu.org/qemu-8.1.1.tar.xz"
    sha256 "37ce2ef5e500fb752f681117c68b45118303ea49a7e26bd54080ced54fab7def"

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
    sha256 arm64_sonoma:   "aae6f81773760cd3c5dc742202802a2ac655291ccd519e32f4fe99f59268422e"
    sha256 arm64_ventura:  "23814bfe0b39b2d8e27ce504a0e9e0d90131f89096e7916f752143d81b18875c"
    sha256 arm64_monterey: "ce028b8eec01f7531662b57fcbebe201ebc17f20cb0688c1e8e0e4c17e1d80b2"
    sha256 arm64_big_sur:  "9fb0405a0ed2edb5457f11bd7ff95ee95e1d0ae80f71abfcc5ebc48987eaadff"
    sha256 sonoma:         "6b700e13cff50edd3bfaa11959c5fc90f3d220c75245852087a14e79e8a67989"
    sha256 ventura:        "f3647d5197f7a14d7ceff873c31a17934982969fb80c1c68fbc69f7c774603f1"
    sha256 monterey:       "5217ea26acf78a933e75f80e21e5ddcee0a3018cbd1200b180d285fce62fa5b7"
    sha256 big_sur:        "37e9e3e2734c037975b785a2a8cdbedc771c16d6027352d5438afb8d86f71b3d"
    sha256 x86_64_linux:   "701ef6e55ceaf746ea77d5eef31fbb2302ee8fb49739807fc2894dd4ba49131c"
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
