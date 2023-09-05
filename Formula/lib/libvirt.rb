class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-9.7.0.tar.xz"
  sha256 "d8c758fe7db640f572489caa8ea6dd8262d169a4372326c23a3a013cdc40b8ce"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d55e3fc6c457032f8b2c5b44b75ed77f01d2a4a3a97f2730b60da23d350963d7"
    sha256 arm64_monterey: "58b53c8a7cb208680027e6d455c7a2f4f2ffa99424dd9e857a4861510dd2bcc7"
    sha256 arm64_big_sur:  "c7f5b81a05b16010112365e45e36bf891a4402ee9bd848cd3b61c13727709afe"
    sha256 ventura:        "20c31db122628dfc7625b608c0a37cd3add2b82decb86fb9e440affa5b9f6b4c"
    sha256 monterey:       "2065626ec360f21b3d23844cbaa2b3efbd523a6cfedef41a71bb44834ae85553"
    sha256 big_sur:        "e9edb7b67225a96e268844166bac23d71a4b8388d2a9c291ad824dffcf6e3383"
    sha256 x86_64_linux:   "bc8bcc24c133eeabcd4651539a68490055a651a4827059d37b4e8756ee4c5d10"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
