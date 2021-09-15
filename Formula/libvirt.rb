class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-7.7.0.tar.xz"
  sha256 "1b616099c18d14b9424a622f2a0bd3e0cfa286414f3416bd1a8173621b2252b2"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "c5018cfce8e96fa66feb439f00abff2fff2043e94cde5fac3fb50d033a1986b8"
    sha256 big_sur:       "d0d3c1a8d8eed20cbce36ad2fc90c07583a682cbdfcb176d558151a4efb3ffa3"
    sha256 catalina:      "ac9aba9184b948b8711f8c9ce73aa20381df8c8a82202966fb16eb36a0613be6"
    sha256 mojave:        "d12670e71fb2f6e7144e47f605961758ac2e50995328020b2ccb89d62005c378"
    sha256 x86_64_linux:  "ca4f29f548d2a0d4d08edeb9dd4deaf7197f56f9e3786013c1b7e46a3d1f9d45"
  end

  head do
    url "https://github.com/libvirt/libvirt.git"
  end
  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
  end

  def install
    mkdir "build" do
      args = %W[
        --localstatedir=#{var}
        --mandir=#{man}
        --sysconfdir=#{etc}
        -Ddriver_esx=enabled
        -Ddriver_qemu=enabled
        -Dinit_script=none
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
