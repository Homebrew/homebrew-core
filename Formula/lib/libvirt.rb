class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-11.5.0.tar.xz"
  sha256 "2b63b9d60538e1e2fa4e3f6d836409e6ff705249c79001914ac3400859d72423"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "292f617b69de702861fd90bccf2da9ecd1f4cbe51c129b3007062175ec3cf08c"
    sha256 arm64_sonoma:  "1c3908a7838582dc8dfda6994f95812ad360292419aff052a2269b48228df625"
    sha256 arm64_ventura: "d0cf4eb8c624c979a4d838b116621c140cd5974079ac78f6339d307c56936713"
    sha256 sonoma:        "251cdb13ea5a8e321321516af4ea350653f61cd08ea078736594061c56a3e470"
    sha256 ventura:       "213c9eb2b72ee620c78eb513e3f4f400dfd5b69818d907fa5db7d112b0a5335b"
    sha256 arm64_linux:   "2df68423fb62a6c682761072e417ac4878f319d0cf3e3161f765e8ebd5ecbfe7"
    sha256 x86_64_linux:  "fde0dcbf018f1f3b07a9fef099ba16d00ccf3f07619f2583502fbc06d3f15769"
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
