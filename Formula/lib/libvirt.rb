class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-12.1.0.tar.xz"
  sha256 "3b60040a3670ec014d058ed021ae641e9fa6d3b5c4b56e63e8928f1804ef4b9b"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5c5609f8dc64a0d848fdbac4a2635d34174338f12640f9b69b341c90136e9848"
    sha256 arm64_sequoia: "5fb67932e62649df485450aafa1ba92769ab3cdf6cbfa111a636c4b1268940cf"
    sha256 arm64_sonoma:  "7a9fc8746dc9e94c5436cf0ca7d3e27eae4b841073b0b921420ba265c63566a9"
    sha256 sonoma:        "a860275679f1af425e65df4df1b86c69ec36eba502a6da59d908d308bbd23fa1"
    sha256 arm64_linux:   "7ee99bde8d82100e8c73d999540e9094a308d8c29b7303afe2a0ea019a76d086"
    sha256 x86_64_linux:  "e0d76f3e68c3faa0e41ff3d1302646d2ea41896c9c0bd41838c1b981cd6bf7c7"
  end

  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-c"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "libxslt" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
    depends_on "cyrus-sasl"
    depends_on "libnl"
    depends_on "libtirpc"
    depends_on "util-linux"
  end

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
      -Drunstatedir=#{var}/run
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
    assert_match version.to_s, shell_output("#{bin}/virsh -v")
  end
end
