class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.9.0.tar.xz"
  sha256 "104f70ee591e72989d4f8c6caa79ed9dacd5dc84efdb0125b848afe544ad0c2d"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0d20962672b70fb458b70211e30a7efdd52f48278ff077ffd18b8324716119e7"
    sha256 arm64_sequoia: "f835001451b5c6cb6ba0c9d8a69fbf18487c354f0c66df9cc92bf061176d1a0a"
    sha256 arm64_sonoma:  "0b5991e43e5a6cdbab42d281446c39f31a08a1b7b1bc0a7f88b97e1dc48c99ca"
    sha256 sonoma:        "ce8bbc5f450fd61e5add2ab958be633753a9c45feb9e843ad7dd5876f0c8932f"
    sha256 arm64_linux:   "6f6eae64e8d7440b395f51386090c00a53c13f21724a2fbfe86a1802dac904e4"
    sha256 x86_64_linux:  "1c0d8332e6bb501d2867b10dd1ea6cd3faa87e629b56f918f5b62332ea92a003"
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
