class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-12.7.0.tar.xz"
  sha256 "7ec1a04e7e4f4069353d4daac117bbe869287f5b202695de61fe1b079efb6cb6"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "24c29d307457abf1e1b704b73953231674f3bde5e49a7bf5dad2097e0a8fdda8"
    sha256 arm64_tahoe:       "9025d82b3435e0c1b929f3f1fa81239a46c35541c5192bbd8abac0eeb6388b15"
    sha256 arm64_sequoia:     "7a2114ad7d04909c0ffd0f0f82a809f9a8ac537dd5022b0ea3854c445c2d9b70"
    sha256 arm64_sonoma:      "f3e93c483a9a28737926e9f95fa97cb77f09c626d490f6b1dc8d2b393f6445d4"
    sha256 arm64_linux:       "e2ab35c5cb1aae208f7d1c61e115f910398ec27be4922b1eefba795e9fea9968"
    sha256 x86_64_linux:      "764c774304332bcb420126fc205c7ce962ee5836a99d1d2c6aa869b1b123814f"
  end

  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cyrus-sasl"
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
      -Dsasl=enabled
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
