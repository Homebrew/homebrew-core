class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-12.0.0.tar.xz"
  sha256 "bf4e680019c04c45b557dd4a7ef59e952887f74e3c47044fe035a961fb624726"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7e0766b892dd5708a71a14c98c15b22c3ed6f617b7a3c959332ddc75267407c1"
    sha256 arm64_sequoia: "010f618ed52cb9e765d2faa6281980aa4bcc53fd30577f696480cf0677675eb4"
    sha256 arm64_sonoma:  "3b5d74a3e8dc066dadedb835d1b96a9f9e7ba3b1562c8817b0c41dcbc3e11af4"
    sha256 sonoma:        "7aaa49b391e42463bd6f30410ea6ac3d6cd1fddee6aabfdade48d294568f8688"
    sha256 arm64_linux:   "2433e565e90b890865b7c273447a0697ed76a30dd8baeeba18da831264858660"
    sha256 x86_64_linux:  "7558fc3294913c60414ab852494743472cbbf0fe7dcfae00f56a64ce4e86cf98"
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
