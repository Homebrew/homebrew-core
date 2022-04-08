class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-8.2.0.tar.xz"
  sha256 "0ecd9c7dd52db7a2d124155ffa5e11de2fbd05014eceffbd1972b022d21becba"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3d7ac1096818d63f719984d8eac4f24bbaa015d8250a2af4a2dc9fd4b1fce051"
    sha256 arm64_big_sur:  "eda6e110aa9820a5fec16e9c161468bba0a19f54dee51436b0a33fe610f2beb3"
    sha256 monterey:       "9d36150a4d26b7d0442ed89e7d520248ddcb213221d8ec41c55786e30f3d5d2a"
    sha256 big_sur:        "249c7bba3865ee9fd6f508cc78e5da317f806ae52daab208bb670b3547fc67c7"
    sha256 catalina:       "7f98509924e3f308b40aab4c2d257f8274436b987d547e14a8f53a0d7cf6037b"
    sha256 x86_64_linux:   "24976989adbe16868dd660d879382c3dc266ac08d2ba817aacc3b22faf9c1203"
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
