class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-2.1.0.tar.xz"
  sha256 "1a799562337472ab00f76aa30a53d54c623c96633070ec53286c9cc2a456316b"

  bottle do
    sha256 "49b0bbb4918ab1b29fbb12deb0d57ee9115bb069c47f52dd5676e915c4361e42" => :el_capitan
    sha256 "d8068db824e0090c657caf952b6d8cb3a5ca95f92cc7c032405cf25f00b0f1b4" => :yosemite
    sha256 "852894798a30c9712d8608b5975cb8f1f01a101bef156f17024f75a98a136d35" => :mavericks
  end

  option "without-libvirtd", "Build only the virsh client and development libraries"

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "yajl"

  if MacOS.version <= :leopard
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
  end

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
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

    args << "--without-libvirtd" if build.without? "libvirtd"

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
    output = shell_output("#{bin}/virsh -v")
    assert_match version.to_s, output
  end
end
