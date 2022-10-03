class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-8.8.0.tar.xz"
  sha256 "eb0cbb6cd199e7a2f341e62f5410ca2daf65a0bf91bd522d951c1a18f0df0fa3"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "fa48c8a6c5142745ab9a45986de4a880aedb7871f91ec0ee13d798da12c87718"
    sha256 arm64_big_sur:  "7a30b97876d627424dcd89f4a4dc998eb0d002280120b556bba6bf721aae4f1f"
    sha256 monterey:       "164b10e7549c2eb47c82dc7910b541fa59223b4c3e292dbf1f57e49ae166b1c2"
    sha256 big_sur:        "3716c37b8d7ce8d69217d33fe4fde0aed115b5c2ecf84716138deeb2cf3cdf07"
    sha256 catalina:       "1b65b1e372d38f4d17f445e5e99f70d7bd89c3a9b50d63ebbbe119ff10971ecb"
    sha256 x86_64_linux:   "e57b83bd5972ee640aa84b3c7f724d4b7b8a9d3512e6a56ada75840584ff0775"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnu-sed"
  depends_on "gnutls"
  depends_on "grep"
  depends_on "libgcrypt"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "rpcgen" => :build
  end

  on_linux do
    depends_on "libtirpc"
    depends_on "linux-headers@5.16"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
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
      system "meson", *std_meson_args, *args, ".."
      system "meson", "compile"
      system "meson", "install"
    end
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
