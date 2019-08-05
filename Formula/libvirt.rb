class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-5.6.0.tar.xz"
  sha256 "65f4f9924e10135aa694ca8bcb0b55725883d08e0b32c42111603d573aabb9b4"
  head "https://github.com/libvirt/libvirt.git"

  bottle do
    sha256 "71f69eaa496300883d76cba5dfda35045a1064c66c72f2a79e34a5e4caea8591" => :mojave
    sha256 "9cadaed9c45ec6caef33734f247b804e6041ec31cf58e0d884cacd254c9a0909" => :high_sierra
    sha256 "d3ecd370f19c0911e673be0e7fdd583746e83b1deb315a7443a29b4dc67252b6" => :sierra
  end

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
      --with-qemu
    ]

    args << "ac_cv_path_RPCGEN=#{Formula["rpcgen"].opt_prefix}/bin/rpcgen" if build.head?

    system "./autogen.sh" if build.head?
    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"

    # Update the libvirt daemon config file to reflect the Homebrew prefix
    inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
      s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
      s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
    end
  end

  plist_options :manual => "libvirtd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>#{HOMEBREW_PREFIX}/bin</string>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/libvirtd</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
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
