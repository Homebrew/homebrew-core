class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-12.4.0.tar.xz"
  sha256 "c86c7f758391b895ec90f76f965a56266167028978ac6dce824fea4d6a036b6d"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a29acb1e4cb01de54d7dbb7f8bf824da5359b48e1c58e473ca87e346b5996b59"
    sha256 arm64_sequoia: "b043887a35b962052be163c2a4201075825e73da70373eecb2ed847302ff30ba"
    sha256 arm64_sonoma:  "83a6c207e566e5cfe518fcbd01ae9bb7aacc4ed0976ba9ec814defe521fbd27b"
    sha256 sonoma:        "7e722d313b3619d72caa4ed3548d4c9bc3df9b6d0b440503add732938ed94b86"
    sha256 arm64_linux:   "56f25ccbf2f633dfe59d757cde7e346eede094ee23f9d4fc8f93482027e0c352"
    sha256 x86_64_linux:  "8545215063c5257b4b23cef2cf620a77beb0478adcb7555b61a00fedfdd48007"
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
