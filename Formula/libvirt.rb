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
    sha256 arm64_monterey: "aa404bb11a253e700374bd73caf7f87e33a4b09112930a0d597a1a546c391364"
    sha256 arm64_big_sur:  "2f249d0fd241fca5a71d2281c4c764df45a825d36a50b32643154d7dd6126c11"
    sha256 monterey:       "eb65637bc8e65d325e5ca26a6704fc8a032ecb26c59a531e5efe35cffb5c986b"
    sha256 big_sur:        "5baf35f64619a6307050cf5481c26ebf89455fd2dc8d1a250becdafdd06a5a34"
    sha256 catalina:       "71c9b3acb18adeb344af29260dd6d5e9343768794ad42400ad561d4abe4f7ed5"
    sha256 x86_64_linux:   "36f042196aae1361e610f5954e4ae68c24ac5a29f0bc95b19e6c577ef17feb2c"
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
