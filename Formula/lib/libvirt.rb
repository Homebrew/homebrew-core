class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.8.0.tar.xz"
  sha256 "f7882fe65302bbcf804b573e0128c4fc6bfc52c9c3f44852a04de2391d858e34"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "af11bff3f437509fdf7c5f568cb6f6535bfcfd0c877233306068139ae1ed6b34"
    sha256 arm64_sequoia: "87c5628c0ab869dda24b9c92eaf80875c657d8c7949f68da49ef3365b4dbd10e"
    sha256 arm64_sonoma:  "1a9638cc17e20832d92273cebb1d0b37b50776b592eda0654210e316674cd136"
    sha256 sonoma:        "f95328095945a2c627e1b97a3479b1c3a9b38f157d2d3b18ac4595f3d15a0aef"
    sha256 arm64_linux:   "e96c24edb67c33b2507721cb2307edb9d4e41cad870dfa8b678c73f3f7268487"
    sha256 x86_64_linux:  "5ffe4f77a04ce9d561d993fe3d76919f17e95e94e17c42e4b3b854dd71313988"
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
