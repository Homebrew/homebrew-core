class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-2.0.0.tar.xz"
  sha256 "10e90af55e613953c0ddc60b4ac3a10c73c0f3493d7014259e3f012b2ffc9acb"

  bottle do
    sha256 "b8eca973a86ff46830181f18d318295991f561fd3b672b8c874cff7e8e8ae2de" => :el_capitan
    sha256 "0a63f4aecf98011d75d5486d4bde3cfcec4c8056849f85b795c020ca56caa278" => :yosemite
    sha256 "2959093b516c41b971414157d11b0e0033677d13cbb306d0d64c329f423e6b6b" => :mavericks
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

  patch :p0 do
    url "https://gist.githubusercontent.com/nijikon/b0d91afdfd3bced10ad27da329fc88cc/raw/f74414747037a4ee80dd7a8dc07c01b2adb6730d/libvirt-2.0.0.patch"
    sha256 "b4a23e6724350decc90a4e5729f887843a9dd8cf9c476557a4c8adbc2ebbe61c"
  end

  def install
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}",
            "--mandir=#{man}",
            "--sysconfdir=#{etc}",
            "--with-esx",
            "--with-init-script=none",
            "--with-remote",
            "--with-test",
            "--with-vbox",
            "--with-vmware",
            "--with-yajl",
            "--without-qemu"]

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
end
