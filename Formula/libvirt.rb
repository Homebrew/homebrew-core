class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-2.3.0.tar.xz"
  sha256 "e430e69b27d3f6c97255e638617b59b179618d531d81ac7dfe0783a1c1eeafd1"

  bottle do
    sha256 "595aa1692fe2510775abe9080c488ea5992666540154bfe25df39044ca551d23" => :sierra
    sha256 "099d075c61d5833c301a6e96873b86f124c69455fac75baa5459a3ffb67efbbe" => :el_capitan
    sha256 "1e207723a00f8a00a0d4de751d2bab1af2f5b9e88aca52f6d0fec9dc21464b7a" => :yosemite
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
