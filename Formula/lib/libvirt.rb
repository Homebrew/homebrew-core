class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.2.0.tar.xz"
  sha256 "07b91052b4e44cf2e5c21bfe1a8095f98db47a917b38d95d2a7ec50ff6bdade9"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1e85ba454dfb2f805457d8fbd881c349a39e0fbfd42fc8b0b8bf3ccb48a6b407"
    sha256 arm64_sonoma:  "c57e2fe2d0472e93a29a848c6dd7c59972a42c9de42863fe808100cf4dd661ba"
    sha256 arm64_ventura: "78decedec0009ad6df17c4426cbde9878aa3af04303235af7ae68812ef937e9f"
    sha256 sonoma:        "8b37025b9a456045c042cfb7e3638ad7ce611e1a132c6d262b0f9795be4cb796"
    sha256 ventura:       "f26764bb45e2c9fe17172e6e5b50f4a09fd46afac9e922df3c32fb96565a5054"
    sha256 arm64_linux:   "66e7ff70ff879699c979395021e522e083b3e69203309670aced16735e636fc8"
    sha256 x86_64_linux:  "e809e9c6e2c93cba6adaeb88d29b5429a75068cd0a0824ca96defedfd54ca7bb"
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
