class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.7.0.tar.xz"
  sha256 "dd56db0ced8baf668f476698db9956f160c93c0ec0c47a0603843235bf156f78"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d57e7fdc4ee91a761e83a2552ec31b7d70ce135eabdb02fcdc17fc83e2b2e394"
    sha256 arm64_sequoia: "9190d52a481ddf2c476d47e73127258c01898c190ee8101dbe7ebe238aa91ba0"
    sha256 arm64_sonoma:  "14f46abe7c396d4e26b42e2013118aaa821167227c38c6bd5173d6b26ee47740"
    sha256 arm64_ventura: "78c6ad72f2fb7cc20260a2dde633847c58b392075269480daca0f93eb7e35332"
    sha256 sonoma:        "35ac9de000f1f6f4ee0cb4483c6f468ecc7490e6ee461e07aab825c2fb2b13d3"
    sha256 ventura:       "6023cbdd865fb2738265cfa5c15309af2db75e347f0a47e062cf461cdda88e49"
    sha256 arm64_linux:   "62d50432cd2e5d866bbbd19aa88e743ac1659ae99bbbda19aea2c1b25ffb07c9"
    sha256 x86_64_linux:  "f3fbef5e1688955650e1195bfe5696503a21e1d86339bcd3c89a5447863a8ba9"
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
