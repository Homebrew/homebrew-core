class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-10.10.0.tar.xz"
  sha256 "e1bd7bd31b7c0d0ae073dec050bb5b0232b3e4adebdc58ea82fe8b366c765796"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "9094ac30ff54af664da6970d925cd2005d825f4a0b0194901d6e177612b31498"
    sha256 arm64_sonoma:  "9bce4a05149ced8777dbcce5793ac14e712102ac036feb41d5ef947d80281e97"
    sha256 arm64_ventura: "4d6bfc8ae9c58618f89298f399e0ded53efa44985b783b7797c37337278b2903"
    sha256 sonoma:        "cf54b26fd6a9c0218870b9afd90269c31942eaf88c3750eb85750b3b22b2ce91"
    sha256 ventura:       "689c89423e0077b48efd1e007c1eb89686e36570b88d977af2b79151f21e46ee"
    sha256 x86_64_linux:  "6a5dd2e16ab26f86268b8ec2506901f80b5d82903d7d012de265b6976174c0c5"
  end

  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-c"
  depends_on "libgcrypt"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.
  depends_on "yajl"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
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
