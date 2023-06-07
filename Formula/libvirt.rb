class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-9.4.0.tar.xz"
  sha256 "4862a82f76f3e40f6046e58c8acda281bd5935d1d33eb211d198c856456fd6a5"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "812f7ca8c4fa23b58d384af7c3cc804ccfa3b885c32841be306ef7f38d3de267"
    sha256 arm64_monterey: "f065f3c9ec51585dc190dc9aa055a128ab17d1f7511e716dff774b21a552a798"
    sha256 arm64_big_sur:  "5891e68a16b17e13ace7859e1553d412753d8437a0b905acd57700b1ae6a6ef7"
    sha256 ventura:        "0154013c5bf5ff7dfec718be31072e7030d993350af964fd29bb360fca6b5447"
    sha256 monterey:       "69af65b5f4a92d1e9c91e70c5d3bbb592ee7a2c7a855b169a1ade8d48a692d64"
    sha256 big_sur:        "9f5ad3406eef5d5883eadd27e0fabcf07058c137901dfcf09033d60e82cf0bf9"
    sha256 x86_64_linux:   "b6e05ef78150a82e5b82055daa1d45a64dbb14a12802b2c4990791afe0d2fa15"
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
