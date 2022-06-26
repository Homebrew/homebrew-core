class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-8.4.0.tar.xz"
  sha256 "601a6e9bb03a43d05659f63e4a403df253ab0975b4a973f10a5607f3bbc018dd"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a75eaa89a40a4c197a5a2860fa1db285595826a60349b34c8ce4c0508b4a43b5"
    sha256 arm64_big_sur:  "57b5b9288a66422d46f39eb07a67719c82fba387542113d70422a3087eaa9e00"
    sha256 monterey:       "12d72abec429bc149c7ebf9dfdfb5f877e2c3cebd9de72e25f0b739396d8df5b"
    sha256 big_sur:        "7644a045ba234c080286b3236f3d796c1b244c5385dcdbe64c100ea9766b0da0"
    sha256 catalina:       "8aa749edc9a1a76989c3d5eba5500c58bf514804c9ffe794c9bc9b11ae06a9ad"
    sha256 x86_64_linux:   "189a157b80c3fa5e52ba42b7d5b12de1c83ebf3501dbe4fe2b027d2531e9d946"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnu-sed"
  depends_on "gnutls"
  depends_on "grep"
  depends_on "libgcrypt"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "rpcgen" => :build
  end

  on_linux do
    depends_on "gcc"
    depends_on "libtirpc"
    depends_on "linux-headers@5.16"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
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
      system "meson", *std_meson_args, *args, ".."
      system "meson", "compile"
      system "meson", "install"
    end
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
