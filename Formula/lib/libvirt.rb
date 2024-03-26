class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/libvirt-10.1.0.tar.xz"
  sha256 "36d9077e2b0ef6b0c6df3b42e42a67411b6ce3b1564b427b55e65019dde60eed"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://download.libvirt.org"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1f59a7a7637793eaef1bbbaa73f995d0bee7030f5d4cac534180bef1eb7019ac"
    sha256 arm64_ventura:  "e26cf34fb932562261e9e247f8b0755889c21f7bd6333738f0daf51c0bd1779d"
    sha256 arm64_monterey: "dc7229871c3ddd514abe52f7c0f8d674c18a2a49d7b5317ad3da01b38de8b496"
    sha256 sonoma:         "e1c966bbd1b3fd9bd28906dda8f5a52fd3bb14bcd374a414452e4b3b2ef53e53"
    sha256 ventura:        "c09cb905129ee0288f35235e03635782c109bdbd59c1ba3f48b70dd82b50f10f"
    sha256 monterey:       "0171c508d1bde6002b5593a82ae6c639c4262ec22405df78f9aad22cc0a24e8e"
    sha256 x86_64_linux:   "857b121994f96a1a54465d87721558c67d5f88dd070a0d49002bc8c9c1b332d9"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
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
    depends_on "acl"
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
