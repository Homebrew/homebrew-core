class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-7.9.0.tar.xz"
  sha256 "829cf2b5f574279c40f0446e1168815d3f36b89710560263ca2ce70256f72e8c"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "5477d07e4d0af7a7fa2d917e4ec3598f882fc799cc25f8cd4b0caab7362f9486"
    sha256 arm64_big_sur:  "dbafcc4b737970c148bd250225ac8244199deb48f9c04c0c4803d1ae11fde988"
    sha256 monterey:       "c874537c4fe979ebea31f708cabc54d76d4b0bcb80e53f790e2b5be5f674cae6"
    sha256 big_sur:        "4e6e779af1394b7fdcf7d9c04e93d7977067fbcb0489a124e178519f6b044ea9"
    sha256 catalina:       "da0f91b819fa59872ce93f6f31e0b9f6c579f7a595718728e84ba989a2447ad1"
    sha256 x86_64_linux:   "69f4a06f0b969e8d704e82b086172850800d835ef12609026e9f7a2850d6b695"
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
        -Ddriver_network=enabled
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
