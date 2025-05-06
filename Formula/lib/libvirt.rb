class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.3.0.tar.xz"
  sha256 "6bcb0c42c4580436fea262ced56f68a6afe20f7390b1bea2116718cc034a0283"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 2
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "eb5a270a4de17ef61be4e8f9c7d00e0fb003ef8fb2dc970c8cd1255e7ea32c15"
    sha256 arm64_sonoma:  "cc170ed47e7e550345da3296b72e86d0a1759ffaf3f14c65974459e234dfad75"
    sha256 arm64_ventura: "65c8b92db1e6d58aea67aac00448fefca690bc2457837f84023b37a104f3f470"
    sha256 sonoma:        "88d41ab9ba9fe5980bb9a3e869e3669e2e5f280ed33340de6f45e54d5c9421bb"
    sha256 ventura:       "0e2a8417f55d20788baf98c5bd5a8ccdb34d4039167754c745def0742b23f29b"
    sha256 arm64_linux:   "0e14a9db24adde346e44f2bccdcfebd0931382df817e6d3a966a22c3c843dfd0"
    sha256 x86_64_linux:  "61774ba7f4c60f67de0d19b17bce4cb8607bd84ab670bf9b7e207e9c74a99bd3"
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
