class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.10.0.tar.xz"
  sha256 "66154fee836235678b712676b2589c45f66e3d6a8721ee0697c9f20a66cad0d8"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d9a3a6eff482497615ff9563ca04cb33a1bcc0c3b1181ab4157a01b5fed74674"
    sha256 arm64_sequoia: "4ee2fdb66753b200d128e045cf6f0b919df62682195bcd00735e32a9e56e491b"
    sha256 arm64_sonoma:  "e50dc20c7f39ab7ed714f34ae273e604d22f82a3d37c447dee7783f77df9acfc"
    sha256 sonoma:        "710cc28a5836cd9b947d2a571941e267ce54dc8b6666ec25c48d9480d7b16c41"
    sha256 arm64_linux:   "682f89989f94446da0cf6fcb23a25f0980af1973b36f2247c5b447456105f012"
    sha256 x86_64_linux:  "8cbd53c67b20a32b295d02cfd8c08fc9d17834fa712baec2ae1538ea2136922f"
  end

  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-c"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "libxslt" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
    depends_on "cyrus-sasl"
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
