class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-7.6.0.tar.xz"
  sha256 "8f967106d00aabb3cd692724bdd4a9c09e71cb2245053b98193690ee01766141"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "8f86ccc81d09112ce826c382bfefb74880c9dabfe186b9c83bf6d935eba1611d"
    sha256 big_sur:       "5bd53310057ed0d72695cb176005bc8ad1bb320f4cb67c9b74cb1a2582631103"
    sha256 catalina:      "dd979706fd043654f4393ee331607c325df0ca0012b3eecc8579223cbbd53bfd"
    sha256 mojave:        "ba7df55e6bcb315e6ab46111a1e4a0824ab72c44888cd01f2d4821860f163dd3"
    sha256 x86_64_linux:  "e31b155ea6e7e306875c78d43e28828ebc01b5a5210fd0a1bacbbf271a6f30dd"
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
