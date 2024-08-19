class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-10.6.0.tar.xz"
  sha256 "a495b2a26faca841ac0073c7dd7f60857ca81adac9047dac5f698fd75f1342cd"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "aa07915650efc8bf4d78481ca4f585ba7c02789b1010afd580c029a30294677d"
    sha256 arm64_ventura:  "934dee0d13f6bf5943e935a417d321b1ec749db24e23aabdd679602dbde43894"
    sha256 arm64_monterey: "a97f05911e9d91d79039a4c90ecf9ad946496c68e335bd26e21b989438c44780"
    sha256 sonoma:         "0a44ee27ac49b2f9f3f1f7458dd3c4a42c80db11b5d7fe948b3e6981bc0b6a40"
    sha256 ventura:        "632a041625a6f67def2ba85aeca35226bc45a8e3f84be63bd84be576b7fa85c0"
    sha256 monterey:       "cff5dc104a04f92310cf80a1d98b5320a0df727f9922fda98859649f9a6ded92"
    sha256 x86_64_linux:   "c497746b634936b079b7c408ef6900b99fe72be4bdd1a747eb47d5c218793357"
  end

  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gnutls"
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
    depends_on "libtirpc"
    depends_on "util-linux"
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
    assert_match version.to_s, shell_output("#{bin}/virsh -v")
  end
end
