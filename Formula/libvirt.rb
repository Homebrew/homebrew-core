class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-6.1.0.tar.xz"
  sha256 "167c185be45560e73dd3e14ed375778b555c01455192de2dafc4d0f74fabebc0"
  head "https://github.com/libvirt/libvirt.git"

  bottle do
    sha256 "8fa2bf2a7e65176f75b8fe6d3fd55700fc5e685653e63af892694f1f87a33ef2" => :catalina
    sha256 "07977c35c89f4bfa0e8c29bd19f8cf13735992735bf5c3791da9d6828ed51bd3" => :mojave
    sha256 "eff1091d09dac40553394faa0ee02c836441f43c9b11416d52e914bbaa5f4a0f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "docutils"
  depends_on "glib"
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

    # Work around a gnulib issue with macOS Catalina
    args << "gl_cv_func_ftello_works=yes"

    system "./autogen.sh" if build.head?
    mkdir "build" do
      system "../configure", *args

      # Compilation of docs doesn't get done if we jump straight to "make install"
      system "make"
      system "make", "install"
    end

    # Update the libvirt daemon config file to reflect the Homebrew prefix
    inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
      s.gsub! "/etc/", "#{etc}/"
      s.gsub! "/var/", "#{var}/"
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
