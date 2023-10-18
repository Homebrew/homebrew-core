class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-9.8.0.tar.xz"
  sha256 "7aa90d133bb301e94663a45c36176f46f4a9fc1b34d77d2e22b7a2517106f506"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "58bf34fada6137e522075c9e2de2691e1622295c5a91f20452c2a3530c629a7c"
    sha256 arm64_ventura:  "e669c91eb3d470ed65b6202b3a0e2657e28c6581ac8097e5c3a214b536903518"
    sha256 arm64_monterey: "48654bf2324166e728af9b32fd2131d5cbe09335fd214664d019c1bb0eaa807a"
    sha256 sonoma:         "c5c5786ac014cbc4a499b0f73e861f2fa5c34c2e4e8436371f0bf86ddb79c892"
    sha256 ventura:        "6a00868d3a77bdf6a59774f11a1af9286f620aeebcb5623ef2b41ddb32cf3caf"
    sha256 monterey:       "17a2fb7dcd0024f0898b321c99e0614b61a26b28ffcd7a72e1dec6b8ca664ae8"
    sha256 x86_64_linux:   "c15f46b3a0892dd8c2fef41eddd8be1c1f14a6f052d8d010abd871f399181e17"
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
