class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-3.3.0.tar.xz"
  sha256 "29e00984174e33cf2183b478382c017de26860452ffee17b73871051264ebb1b"
  head "https://github.com/libvirt/libvirt.git"

  bottle do
    sha256 "cbe6a4b4912b9c95b35529c83d8d6cbb10985090c3f6c01f5cc09edcca737c53" => :sierra
    sha256 "bec1864bc0e65ac993b82ef5c65662fcae61968b51a5aa8e324c6c013337c6d0" => :el_capitan
    sha256 "16de731f628487218bb15d63436dd6b5793657007da7e8e8e073fcfd2a880d29" => :yosemite
  end

  option "without-libvirtd", "Build only the virsh client and development libraries"

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "yajl"

  if build.head?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
    depends_on "rpcgen" => :build
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-esx
      --with-init-script=none
      --with-remote
      --with-test
      --with-vbox
      --with-vmware
      --with-yajl
      --without-qemu
    ]

    args << "ac_cv_path_RPCGEN=#{Formula["rpcgen"].opt_prefix}/bin/rpcgen" if build.head?
    args << "--without-libvirtd" if build.without? "libvirtd"

    system "./autogen.sh" if build.head?
    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"

    # Update the SASL config file with the Homebrew prefix
    inreplace "#{etc}/sasl2/libvirt.conf", "/etc/", "#{HOMEBREW_PREFIX}/etc/"

    # If the libvirt daemon is built, update its config file to reflect
    # the Homebrew prefix
    if build.with? "libvirtd"
      inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
        s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
        s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
      end
    end
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
