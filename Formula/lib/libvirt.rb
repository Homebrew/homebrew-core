class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-10.3.0.tar.xz"
  sha256 "2af5a50b6b1027822b6344e35080fa78cc8266f821a3ae6f8f372f18dd049018"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "341bbab1e2391bad27fd3005fc838e7a4f2b3813b5a95603079e087629e3261b"
    sha256 arm64_ventura:  "6b17437183629c7a220dc83893f139019a01968b23d821a634eb64360d527f4d"
    sha256 arm64_monterey: "b1cff4f96ec580c584798bffaeaf3b08e801a2484d945884d333dd20089c7d26"
    sha256 sonoma:         "e33bfafe1d565baf2bf994b6eb492b5817949b08adf1c1fcd4734bb3f2403a87"
    sha256 ventura:        "7497f2e13255e4dd70bc223df782cb611f72d24da7957045f1c601da6ac4238d"
    sha256 monterey:       "7e1f5656f3a6a492c594672044047c73170c8560434955645a3e9e8262c843b0"
    sha256 x86_64_linux:   "3fcbeb4ce6c7a4b14f45d634d928c28f2f8f84c4577173ce881ccd2cfad6a330"
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
