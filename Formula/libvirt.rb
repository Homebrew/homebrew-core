class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-9.0.0.tar.xz"
  sha256 "deca5cff1b7baac297bca9663907c61f71a47183371dc7ac019c107806d5435a"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "402a89194a98ec8f0b2770b445810bd7beb67ed171344eb9f9fcee8f15ba116d"
    sha256 arm64_monterey: "831811c79b2361f65bddddbc0fcfb7eed9776cfe59214c055a2be54c6f4cded4"
    sha256 arm64_big_sur:  "bf27a096b9a4fa31d7d4b6353df15a11be0c30e412d8dbb8a00f0c72533f1208"
    sha256 ventura:        "14cd947ffa7b8749e80703faf377999dafeca993bea59a93bf019d13ea3f50cd"
    sha256 monterey:       "b849d2281175dd130690c7d98ba5b52f7d9222560aec7cb9d42aa329481e02a9"
    sha256 big_sur:        "3326d511d68cdecac06845f4cb1afa000a44946842ea2d65993da61dcbcf6e3f"
    sha256 x86_64_linux:   "a489e0e5ea1d27807b2b6262159bee2fecb488280057615fc19bb2157548d98b"
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
