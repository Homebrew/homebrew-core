class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-9.6.0.tar.xz"
  sha256 "10f2e52dbb5df90410594a8e36d0e0587d38f11efb64ff32cbec422b93b70c52"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5b519365a8f266bbabb3540d59db00b389a491aff7ccb1265d0e0acc14348041"
    sha256 arm64_monterey: "aac6e619b5ed4ac5430aed5c4eb370b69ffb99201b164fb4ad0fd52957d156c4"
    sha256 arm64_big_sur:  "85d9a7afc7b2164415d357132899614dc5039c9d1aaedaefecee82b68899abb9"
    sha256 ventura:        "7624c5d194c86f44b29f6033e1521d5bd8e8d4b5966010cf2e86d23727a69394"
    sha256 monterey:       "8b6c93306b7756bfceedac6cbbfa9ee50dfca6bb618b0d390bf5904ab81ba294"
    sha256 big_sur:        "de7cbb3c0555206262222db03d20d9186cfbfa5f8f783e3011448dbcf65471ec"
    sha256 x86_64_linux:   "4a64640c413fec8cbaa1b90a18c0dc6a2a9b79eea90a698b3a9d78011a2d03eb"
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
