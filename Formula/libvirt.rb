class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-9.5.0.tar.xz"
  sha256 "df5ea2272c4d1ce1889892d88292506616c1e10ebe8ecdeac7928f2ebdc3044a"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "66b9780dda1ecbf35d31f43a1a110b1a4f3855b43b97a27fa3802061ed41c000"
    sha256 arm64_monterey: "5eb9d3623a91208ab3ba1fcd540faebee54ccc3609a82783ca8b4b5a5e8d3eba"
    sha256 arm64_big_sur:  "386794d277345e8ccd25e476608bba7e5cc9060c11b848cbb137f79c5913b097"
    sha256 ventura:        "ac4f038b7b80466668f1d79720d8782f178f0c9d22211c33495794ba1c4a17fe"
    sha256 monterey:       "87fece32e33d6ed10fb8fde0cc3419c8083b065b375f5656527c0011a3f5caaf"
    sha256 big_sur:        "b20e29766d9da4948f295c17ff98c7adbc7b3b9b2c490379b43fd9f42f4a254f"
    sha256 x86_64_linux:   "bf20365c556d9a5c48c64e0a8a6caac75554002ec8c19421ef0e082b2c127b09"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnu-sed"
  depends_on "gnutls"
  depends_on "grep"
  depends_on "libgcrypt"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "rpcgen" => :build
  end

  on_linux do
    depends_on "libtirpc"
  end

  fails_with gcc: "5"

  def install
    args = %W[
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      -Ddriver_esx=enabled
      -Ddriver_qemu=enabled
      -Ddriver_network=enabled
      -Dinit_script=none
      -Dqemu_datadir=#{Formula["qemu"].opt_pkgshare}
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  service do
    run [opt_sbin/"libvirtd", "-f", etc/"libvirt/libvirtd.conf"]
    keep_alive true
    environment_variables PATH: HOMEBREW_PREFIX/"bin"
  end

  test do
    if build.head?
      output = shell_output("#{bin}/virsh -V")
      assert_match "Compiled with support for:", output
    else
      output = shell_output("#{bin}/virsh -v")
      assert_match version.to_s, output
    end
  end
end
