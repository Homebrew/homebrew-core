class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-10.4.0.tar.xz"
  sha256 "d1308be98da418ce463f0d9e4ac28a94b1a859364db3bb078d6e153dc587efe4"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ba6027bae4d3e7d72be3ef531af38511f333c244ef759ce24e42e5ea17d9f39e"
    sha256 arm64_ventura:  "534ee54280f0fbcc62aca01ca391f0ffff9dea4929a3956cb0e876ed067f1441"
    sha256 arm64_monterey: "3bdf47c395b23696ad6a2f10a1fe05f73af65d89e7340e25b567f0a847928e06"
    sha256 sonoma:         "40eeefdb1dd35fb7fa82130cc0b82b167b11592e1db151aa5de6a706462948a9"
    sha256 ventura:        "a3f23703a228eaa4827c8f37fc49b1c298ace4fb5ccdcc018a1fdb32bfafbf89"
    sha256 monterey:       "9bba62dfbeb13f893696bf4d769114c3acf2684ae6f69f15c533c2ba5a8b02b7"
    sha256 x86_64_linux:   "199e7cd75a0c8521ffa7a28c390a62f5514bd36e9e368524f6f2f82ef7245fc5"
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
    depends_on "acl"
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
