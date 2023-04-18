class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-9.2.0.tar.xz"
  sha256 "a07f501e99093ac1374888312be32182e799de17407ed7547d0e469fae8188c5"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8490cc596c1e2e0d6cb934ddcafbc9ef2fd03524549c2483228b1c689bed437b"
    sha256 arm64_monterey: "e97ce4c3bc2a1745a77befcaced6f6ddadc278449b6ee7dd63d9c3a0bb36112a"
    sha256 arm64_big_sur:  "9740937b22116646c3bd18ab65385eb5d7392bf35d226670ec1b34792e272a3a"
    sha256 ventura:        "5cbbd93d3d3e866746150d3b05b57c3ca65c4d805914a9bdeafe0776964b4b7b"
    sha256 monterey:       "d9857386ea6dc3ce2f299cee4ca62fb75aee315c61200fecf593251d6ad125d9"
    sha256 big_sur:        "db11576b9d2437727363dd115cc1e452a932d37fb8820014bd4e9a75148dacd9"
    sha256 x86_64_linux:   "ae99c9c721bb09d55735cf12725a50c092de5fa2ea494c5d8a010b82af0f384b"
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
