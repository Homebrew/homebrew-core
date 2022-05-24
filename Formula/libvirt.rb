class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-8.3.0.tar.xz"
  sha256 "be229b9ad1d48be7007e7bf341fc990c65e24aea624c16db6b36d02c820df5eb"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "426c4dbe77cb04f0c36db7c3d8c30195a8e17c319787930732587ceba283017f"
    sha256 arm64_big_sur:  "4ba6aaa6d5d24b93eaca19c00e2313831d1285d19ea71c8242212a9bc1e968d7"
    sha256 monterey:       "4583eb76feaa0bdfd56b71e7fe6bd8dd50a190e9e67797c354bc46f04938d6e0"
    sha256 big_sur:        "cb9da500b18a2c100aa61f2e3cbb8c6a1b88a71a817fd8454d409d2a9b7ec6b2"
    sha256 catalina:       "ddde93a9b3fb8140411ca0dde4a651e6edc6cd6040504f1a81733fc4eeaa4c0c"
    sha256 x86_64_linux:   "18062dd27a891c0c46277170580270746a851a921d7dd305b32962fa84007cb2"
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
    depends_on "gcc"
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
