class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-8.9.0.tar.xz"
  sha256 "c213575aaa636d41a6011ef59e5f088643b721e1ab1ca3ea05c176c05e9579a2"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4b009f80ba896e216117b4a1b4b1430ea98891d9132d6867ff502faf44d16389"
    sha256 arm64_monterey: "65f0279d9f25950f3ea88b8529c558a46a25e66b7ae41ee1b952e59a514e68e3"
    sha256 arm64_big_sur:  "38d8224f224b188f5800e05a2f2d66d49ac73adcfaff790c368b0a4b4ba0ff59"
    sha256 ventura:        "7e758d99b6b986607fb26a8f0616673db94973ce0fd8436f733ca4d06f58fd95"
    sha256 monterey:       "715aa9af7e8886ce443a95fac5f767937813cbfd49c17b1c1512b6ae3e3d1723"
    sha256 big_sur:        "b59076f3a5450d75df1f62e17cb95f2254fab753b40b059838f911f93b59bf5d"
    sha256 catalina:       "77c76a7d1710cd62301fb5d2311b4e6fdbfbb2fd5f6278ce5b33d03cfa3b1419"
    sha256 x86_64_linux:   "f37b1b84b204f65e05e83a5c63fa9ceb5c4b3066bcb3d9671f7b5b4773bb3f70"
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
