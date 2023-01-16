class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-9.0.0.tar.xz"
  sha256 "deca5cff1b7baac297bca9663907c61f71a47183371dc7ac019c107806d5435a"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "afd35daa718cbce86f84d66c82eaad0c63a0ebe0241a63bde679f379b08a7c12"
    sha256 arm64_monterey: "865a6235ed63951dd92a5964f5285f9742a2a62d1144cab1234d8803f691cc2e"
    sha256 arm64_big_sur:  "b08aaef5e52c6bbf54b6818727ca01d5b80fc2d044a689c4e63b2fc6ca1a77a0"
    sha256 ventura:        "0584a4a8cc4e21289df8424e1033c0010cd930902ad3705a987b4e39b585602e"
    sha256 monterey:       "fdb417a753acfa3e313e1eb50998dbee08c88caab62d8f650ce1548e5256a2ac"
    sha256 big_sur:        "9c0b9a0a5749550e6d32517cea45a6abb88d65bf2f2ac6170d75a11cc786a9e5"
    sha256 x86_64_linux:   "9366316942953c0ecd81140161ef9988609656162be6251536733609c749c111"
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
