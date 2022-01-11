class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-7.10.0.tar.xz"
  sha256 "cb318014af097327928c6e3d72922e3be02a3e6401247b2aa52d9ab8e0b480f9"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f157ec2148e509becfcfa7d2f093a40f2ddef006687a1a503a984a56c20149a9"
    sha256 arm64_big_sur:  "ae5b59937198b088873ea400c601ba99b2930e08186b960b0a0a3338e69afc0e"
    sha256 monterey:       "5f3e532a6f37cc24b9ff38bdfa1ab6deb76a6079af8008504fdc03deae7bb0b4"
    sha256 big_sur:        "6c475624430a0251278ba2e08b49ad0bc59f0634033a4914b62ef854fcb2ed1a"
    sha256 catalina:       "f4bf14b1d3e236a5d71de7cf1b8801adc8bd2b05181ad197975c01adbaa28edc"
    sha256 x86_64_linux:   "6626249198109787d347375c988bf5374677e30ea0bcdd4042de170bae35bb54"
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

  # Don't generate accelerator command line on macOS
  #
  # This makes it once again possible to use the
  #
  #   <qemu:commandline>
  #     <qemu:arg value='-machine'/>
  #     <qemu:arg value='q35,accel=hvf'/>
  #   </qemu:commandline>
  #
  # workaround to enable hardware acceleration.
  #
  # Drop once proper HVF support is added to libvirt.
  #
  # https://gitlab.com/libvirt/libvirt/-/issues/147
  patch do
    url "https://gitlab.com/abologna/libvirt/-/commit/da138afc3609a92d473fddcffa54b2020759f986.diff"
    sha256 "4eb3c9f0ca140a4d8eb5002acde0b6f1234011f82df7d8cc85252be35e8a5cff"
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
