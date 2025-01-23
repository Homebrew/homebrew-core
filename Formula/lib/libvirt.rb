class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.0.0.tar.xz"
  sha256 "01a176ff4042ad58cf83c09fe0925d6bc8eed0ecce1e0ee19b8ef4c1ffa3806e"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "b092d35546e041875cb44212534c268af1edd890ca43dc8791cf7343600a9854"
    sha256 arm64_sonoma:  "1b6ecfc3ea7683e43b90981597f48e377d4f84c1043d685f63f132e436dde12f"
    sha256 arm64_ventura: "6da44d956b8aee804e02e07f1a06cba44d3016ef006dd2df82368b25eba56c62"
    sha256 sonoma:        "f34fff265b817ce46160c0ff32a9db3829cf0c36763c5b0eeb60f2646fc352fc"
    sha256 ventura:       "40fb73f7ac0a824916e4db73995dd128088c95d656c683ed4d3167fb2d4c7a00"
    sha256 x86_64_linux:  "ba000a71c66398bf89a6df3887355bcab3acf94fbe9432ba5cee54e94cc20321"
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
