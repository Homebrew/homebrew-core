class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-12.9.0.tar.xz"
  sha256 "dcf579d8a949f4cbf56820529d48f200382a48ea12855ffded7c16a189353cd7"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "87f2580b12b4572174a6c8f9f2e3bdf7202aa5b75c7349db6ef11321fa723af4"
    sha256 arm64_tahoe:       "8e8aa7abfdaf2b30fc74525c460a5bada300369c9e0cbc456ad3cef1bfbfc7e8"
    sha256 arm64_sequoia:     "f2cbea9a9e7360ebd9aa71634244892a002df0da6cc0aebe014e3a311b880be6"
    sha256 arm64_linux:       "a83cbb81b3dd9fc92d2c7f2bb5afbf1645b8b40eaf9f9506cbf167198b40803f"
    sha256 x86_64_linux:      "080b9c726f537e5d21cdadaf0358e421c394f0ebeb93a94ff1947d804813ca45"
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
