class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-12.6.0.tar.xz"
  sha256 "1592256deb76fc94028ff083a4d9f06a74f3b92a66a1794f37bc26f21430c888"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b788ca0b02aee2ce2de4f55ab590b157b8a89f70c1a9c4518b4e16171b1df570"
    sha256 arm64_sequoia: "a2b5cc796e7ca74f9c3e67468309ff00b88f28c0a9c27fc8ef3257c498754fab"
    sha256 arm64_sonoma:  "8a19d9842b2cb2a542d42239548ff3eba2bbb502810a48f66f63fd9d2df5dfbc"
    sha256 sonoma:        "68c5cf89556fb8e5f72837072090da320aa9b94c448c2bfaec392712bb06a873"
    sha256 arm64_linux:   "f0a52ea6b2313cde79d0c5bccf1bdae6217ee493be4c91ecc9fcc702516f8e2d"
    sha256 x86_64_linux:  "9a7076429329e50a017c0b3dfb8e5fcb8fed44837f91140861624da885d3677d"
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
