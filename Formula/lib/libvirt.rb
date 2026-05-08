class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-12.3.0.tar.xz"
  sha256 "0d2b548d1b732d1ae21cfefacc204a2c8dabada80ea1edfbd528bfb73b9d2d27"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3cce250f242e7fa560933fb80d3153619fd902e50478e88a5166cd4375380fa1"
    sha256 arm64_sequoia: "3f43d6aae99ba144713fb3749e8759d8f2e32ed89ec6e5455863568284a8e44d"
    sha256 arm64_sonoma:  "7c025e4a2255ee20827c83949bfad1d6b488b2b711011cc0c9289f07997ece95"
    sha256 sonoma:        "5e9060ae5d8c05383ec1701fb5cd7420bb823eec8787d01642df2ae6d3784fcd"
    sha256 arm64_linux:   "0c9067d8dec95a8405ab1f5cd2584f981b998d47e32c7776467c8e6893a2a081"
    sha256 x86_64_linux:  "f75d5a18166f41c1a060981fe76d0498948bcf0e1d025d8a8cb66fe4c66b0ee3"
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
