class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/libvirt-8.0.0.tar.xz"
  sha256 "51e6e8ff04bafe96d7e314b213dcd41fb1163d9b4f0f75cdab01e663728f4cf6"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.com/libvirt/libvirt.git", branch: "master"

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "dc408ef9e5679856b0c3a3200cd9c16c5c7ba270018de1472a8650344c6c5479"
    sha256 arm64_big_sur:  "02359e449d7c2d19ff52ff3258679e1f07c79685fa91f3962104b8267f2c2369"
    sha256 monterey:       "b80fe11b75c15cd46f5aa39e31e9523ef958734a75420e2b19fb7c8814d030dd"
    sha256 big_sur:        "96d763827e880a7100e79283e5e16b2aa6d575b63c7707b290d8536f4530ee78"
    sha256 catalina:       "7f691a6378bef0e100e2b0ae200f2dec72d9d8bffb09595f506a47d1e11f7756"
    sha256 x86_64_linux:   "0e2b445c7794db793d58fbb651cbce64fd6753ad4cde88b23b5bf4a3ad116bc8"
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
    depends_on "linux-headers@5.16"
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

  # Fix PermissionError: [Errno 1] Operation not permitted: '/usr/local/Cellar/yajl/2.1.0/include/libvirt'
  # Remove with next release
  patch do
    url "https://gitlab.com/libvirt/libvirt/-/commit/9f2d3cb472fd4d86dc4de5d57fcf8acb14e33e00.diff"
    sha256 "ee14a4922ddc405c6ff6c5f7e9183b83f50cfa448b2ab9e1428f3f1c47e0d34c"
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
