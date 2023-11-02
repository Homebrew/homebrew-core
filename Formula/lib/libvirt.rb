class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-9.9.0.tar.xz"
  sha256 "cb83be795548161af6718a6db75ee40719a87bcd6f9207a3565db2fc0e53a52e"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "647f1debd7e613806fb032f7280f0a77778417af878b3e2b3fd89ad147fa974d"
    sha256 arm64_ventura:  "233a0dfb5ca7b6db97a9b551bba30fb50cae4083ddc16bcc834ab48747025caf"
    sha256 arm64_monterey: "3ac4ff7a0c7d841433012f0ce129f5e10121e2e3f9e4029dd22974cf98a96fb2"
    sha256 sonoma:         "00c0a0eb102a7e183c156a89da04eb252784f764880ead5fcda3605fb7e98bd6"
    sha256 ventura:        "ce8c80a9cad0057d4a04ab2a141202cc236e861b5ba8fea40687facbee81d899"
    sha256 monterey:       "2ea5972ca3224d9d69137551cc32f8fc1b0a0397a0a9f6624b56eac0081e5dd8"
    sha256 x86_64_linux:   "139274cd54f44c2abcf830790c99e46c514da3235bbb8f68f121afe02fcad608"
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
