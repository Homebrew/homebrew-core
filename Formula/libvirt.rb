class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-7.8.0.tar.xz"
  sha256 "a727cd0a47bfa24fa7de2874d23f3a9f9f02ceb6b49ba15288f6d9a098b19921"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "7c105ea503b711342411bcecdb237b6be0c9bdc0007478c86e1eb181f8550d7f"
    sha256 big_sur:       "5fa6ba649a3e151cb3a98ee397b043f8aca153d24329d1ff00f286de7a58ac9e"
    sha256 catalina:      "4cb61a8f7c2866797bb89894b72152f39735af0b90bbaddd30a5f475a5955d70"
    sha256 mojave:        "70946ecc63511165d972462a20b27cbbc743c85aea7ce1bfdcf504122d277f87"
    sha256 x86_64_linux:  "b304884ef4b54ecbdd974c5ad423862c4b0c4c1e89b4a9a45dfc952e374929bc"
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
