class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-10.1.0.tar.xz"
  sha256 "36d9077e2b0ef6b0c6df3b42e42a67411b6ce3b1564b427b55e65019dde60eed"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f9368ee48068efb258497872e5ccbb6044ed24b10c975e49817f584cb214aa1e"
    sha256 arm64_ventura:  "f6dbae0e0ef931be418762439d849aef0875a92ee951340f9cfdc500f8dbf4f1"
    sha256 arm64_monterey: "08105bc5f72391f1b89b912078f93ab971e510ed69bde30ee731316327cf3caf"
    sha256 sonoma:         "65a2d8a06cdd1ac30c6724d7764a7602b7e306941d33dde0032a53ee309f8ef7"
    sha256 ventura:        "22d5c2807e6138c030cb2d9a36d822152350b19e8272d92ecd2f598398ed8773"
    sha256 monterey:       "7a32ed954f2ac824174492d3f1971f6a1605537511021faaa34fa73f3935e0b0"
    sha256 x86_64_linux:   "277d8f21b21170ebf40a4c6dc1bb27be69162da6b03c93bc9ae38075a5953345"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnu-sed"
  depends_on "gnutls"
  depends_on "grep"
  depends_on "libgcrypt"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "rpcgen" => :build
  end

  on_linux do
    depends_on "libtirpc"
  end

  fails_with gcc: "5"

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
    if build.head?
      output = shell_output("#{bin}/virsh -V")
      assert_match "Compiled with support for:", output
    else
      output = shell_output("#{bin}/virsh -v")
      assert_match version.to_s, output
    end
  end
end
