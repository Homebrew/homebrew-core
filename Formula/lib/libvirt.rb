class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.9.0.tar.xz"
  sha256 "104f70ee591e72989d4f8c6caa79ed9dacd5dc84efdb0125b848afe544ad0c2d"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0c5ec005ef5c1ca7a52f094178f257a81bc0508db60612b47a6f107daac15e7b"
    sha256 arm64_sequoia: "b146f83e6043052182b10646ea7819cb0146759f0ae21b9956f6aad8d69cfb55"
    sha256 arm64_sonoma:  "784c8f9dbb3068da837b7f9d2be36b20c0000b7f4e8d3dde5f06e0ec6af999a4"
    sha256 sonoma:        "13be323246c6e1432851db2c269c168265a84ea02a53d302403cdcd20e46e5d5"
    sha256 arm64_linux:   "b197e1a0fbd42b975ecd449d3c2c4d19c4c47aa23077d8b6171912aa997498bb"
    sha256 x86_64_linux:  "5bf0a6f4e28ef3034fd4ce55e15ff1a4a8b87eabf35281036eface4778cae8b4"
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
