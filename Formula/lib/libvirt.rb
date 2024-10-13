class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-10.8.0.tar.xz"
  sha256 "57e3e8238d31a197f1b26b958bd2be71f99f271a822132afa66f70b7c2100984"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "6cf56bb7bc4686a8ae7b391d554b7c8a0687e35168ae1be46d7d7eddba2a77ee"
    sha256 arm64_sonoma:  "7221d068813a8a988714176a0b361a6d676ef73d2384e08cb44aaf5ec4ede606"
    sha256 arm64_ventura: "0f795db46c0817aef141bba47c5ce81a28e63571e12f486e3841cd920cc9a818"
    sha256 sonoma:        "57ad31b785f13deedd5876e0976c136cfa249a280f2f006c6629cda57274b867"
    sha256 ventura:       "0025df5aa1ec2befd8a194e66a32898d1acba7f0a92fc5d5a9ffdcccb4ddc4bd"
    sha256 x86_64_linux:  "1ad2af8fc03269cb7375fc88956b917d978c9fb0623b6b0c55f7746e5004dc90"
  end

  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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
