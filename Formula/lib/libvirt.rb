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
    rebuild 1
    sha256 arm64_tahoe:   "af9080b779a3e2a67e9df68f2ca27821b8aa032cbca42c42d5afba3abf2b06cc"
    sha256 arm64_sequoia: "e870f30262d09551ad4923e98c560afced562adb91e7dd0c34c0eac8ce0de8c1"
    sha256 arm64_sonoma:  "f3c4c98d458b45251be59cd2ac4d0ec230b756b6d50f8f04109b1d03d65d8c0d"
    sha256 sonoma:        "88c8abbef104ec268ccc61bbb83613c1a0566013613e31eda01b6a70d68f5db9"
    sha256 arm64_linux:   "8b941005f3bd0fce7ce104a8539bc9aa21f4ce806e1ca7fcb4101196496483eb"
    sha256 x86_64_linux:  "2da85a90dc64881f7530c339e37215b1bdb1e62509725020cecf07b06dd94e97"
  end

  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cyrus-sasl"
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
      -Dsasl=enabled
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
