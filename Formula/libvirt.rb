class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-9.1.0.tar.xz"
  sha256 "defebea252a24c1800fbf484b14018b6261192acbac5bda8395e47eba2a14d6a"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a0ad1459d0cd11d37810d873eb1c2fba2ad167a0b4ab5ebe538ed8b44495e413"
    sha256 arm64_monterey: "f0f153f7d349657a44b8177df87f519ed54ea6d3c95ade7f3c61e6de28728c5c"
    sha256 arm64_big_sur:  "220969ba84fcac799a45ed3a4f145ad7dde85a560b5c9d8fbaa84302de9a027b"
    sha256 ventura:        "7c7c79718b8eb242cb398fea929629b476d012bfcfb2bbf548866e0cbce1a3eb"
    sha256 monterey:       "92a10075ddec2c0565e621fa0d3104add7b0da3b2babe78205f9d8662317d69a"
    sha256 big_sur:        "91fd6fb6464237ea7848dd3a7fd87c74deec4c25d7208e88f53d8a858570a253"
    sha256 x86_64_linux:   "6a7c8079937edc6b31676e8285f24fb046721c95185b1ab160540b996368410f"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnu-sed"
  depends_on "gnutls"
  depends_on "grep"
  depends_on "libgcrypt"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "rpcgen" => :build
  end

  on_linux do
    depends_on "libtirpc"
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
    if build.head?
      output = shell_output("#{bin}/virsh -V")
      assert_match "Compiled with support for:", output
    else
      output = shell_output("#{bin}/virsh -v")
      assert_match version.to_s, output
    end
  end
end
