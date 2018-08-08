class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-4.6.0.tar.xz"
  sha256 "b4ac6cd1825d89b9bbafff53f6308f1ac292a44d78eee67bebe01973e2574066"
  head "https://github.com/libvirt/libvirt.git"

  bottle do
    sha256 "02ed246ea3a3974de587d6c4dfd5e4165b867ed8d0a4032ec856bcda951d4b1d" => :high_sierra
    sha256 "4c2df496eeed0572cbeaaa11e238bebc10176e05dcd0494460ac6911eacad3db" => :sierra
    sha256 "98e6af69f60e00a938145e888fee3b4911f6af6ac803d898cf14fcd7b147fd27" => :el_capitan
  end

  option "without-libvirtd", "Build only the virsh client and development libraries"

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"

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
