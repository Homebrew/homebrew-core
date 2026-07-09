class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-12.5.0.tar.xz"
  sha256 "4fff62f08fdf938fe7fd21e260a908a44193cc6d34c42d3b1afdcadd34120357"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7a2c0528571438683454c556f6f4dbc4a79d9fdb3a09eef1bc4bfc44d46f4042"
    sha256 arm64_sequoia: "ce6220432211fa500ae75e63df2d2df06190cfb683f8cdc4ae53fe11268ff4b3"
    sha256 arm64_sonoma:  "069b2e8c35e44cb25a1b27cf864133ab4592e50cfae2a14813e43e8a24a15a7e"
    sha256 sonoma:        "480a5dd159dcec49e87be12be21e78e9145268a1490fb515f3db785a61da6803"
    sha256 arm64_linux:   "2a81ae9e6934166b28e5f92e8cc9b0ca514508f4d47db0a4ef3914a7ae3d43ab"
    sha256 x86_64_linux:  "229040f5e2d7ce84a17da58dae14870959b121458fbd5d0b6bdc04a654ea1a97"
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
