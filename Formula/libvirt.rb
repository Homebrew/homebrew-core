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
    sha256 arm64_monterey: "6c981a8be2a6bedd7783ba881bcb77e8f6c24d0585f84054b5ec4d12d438f893"
    sha256 arm64_big_sur:  "cdb56edc2963115d03b29b427e338c0789ae24c7f964c641b27a2fb5f5dac46d"
    sha256 monterey:       "98b58b34816d86d355740fb916506233c2f0338f5e3a814d4570c456375b267e"
    sha256 big_sur:        "ae19419717f82c5feb72cc37edb6f95cb07fa14ff1c12ce50a72ca8b613b5634"
    sha256 catalina:       "f2431f9bf712ca8d74fe45bfb59e1620d5323eacafebe12cc5beaba49dde7093"
    sha256 x86_64_linux:   "6fa07ea14553b67205e89f4678838449f0590ba83e6af6e4119ee4a7c439155e"
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
