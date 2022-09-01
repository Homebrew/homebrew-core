class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-8.7.0.tar.xz"
  sha256 "72e63a0f27911e339afd8269c6e8b029721893940edec11e09e471944f60e538"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "166565a17ecace2b9c2ff783218a04d73a86fca396267e17fa0413990863178f"
    sha256 arm64_big_sur:  "594417af68b6d41045572d14bdb2be6c456c87421a285d52b74ec34e56d9c35f"
    sha256 monterey:       "aca1724359da823cbae1f9ea0008932e7fe6c3e9459768055fcacace217c10d1"
    sha256 big_sur:        "2b4aa815d9d2bfd65ce807df1107d830f9c43bd29d08970a9aab18c253b7e9b6"
    sha256 catalina:       "7e89bbe7f56b05e2c5b3f35b948ff4ccaa54c95d39b65a6aae6fd7bb1ee385ac"
    sha256 x86_64_linux:   "970358b8ae6d09cfc6a6733e4ec382ace162cf222b13713a65da19ee196bd932"
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
