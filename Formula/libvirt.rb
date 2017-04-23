class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-3.1.0.tar.xz"
  sha256 "7879029a0fcac4e58dbeec66f0bc77771565c4b6667212c8f6251eefb03732a9"
  head "https://github.com/libvirt/libvirt.git"

  bottle do
    sha256 "4dcb8adbe13f081f2fc1403cc47e9dc335a8c7bda32be5856960885e44ae65a2" => :sierra
    sha256 "f9237dee634dfc7b9306ce18b7414bec4b5debc8589464fdc32baaf97175921a" => :el_capitan
    sha256 "d033459dfae7095599f5ec0fe4c12ace01e4a8a501578ede1f921bfbf7868941" => :yosemite
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

  if MacOS.version <= :leopard
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
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
