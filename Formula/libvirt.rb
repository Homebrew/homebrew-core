class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-9.1.0.tar.xz"
  sha256 "defebea252a24c1800fbf484b14018b6261192acbac5bda8395e47eba2a14d6a"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "cc75afa96b97bf89fd6081f45111a5a57d42ba76b9b3e6b3ea55aeeded8c8904"
    sha256 arm64_monterey: "3a29f44beb9928fabd06aeaffac383e2ad6f79c00ca2e57b696919ba98969f93"
    sha256 arm64_big_sur:  "47b581a3bf826640ae7dd4b8be53daf978a562348f303ff4b04f6dcc18b6c52b"
    sha256 ventura:        "9a81be693ca08b32b1819a72bc6e7fd5ba38388ce19201fda4f2feed541746cb"
    sha256 monterey:       "3ff1b7aff29ab47e4c3fe3d18c73231b5057f74c33ad0f4ee8671236a8da405a"
    sha256 big_sur:        "2c8eda21b6d05503cfef0095af9cf6199cff20b07384635fc656e38d1cd9c862"
    sha256 x86_64_linux:   "bb79a9bfa9a59cd6fc5d836230e1c50077ade0a007530cf96314dd85d5c3da98"
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
