class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-6.6.0.tar.xz"
  sha256 "94e52ddd2d71b650e1a7eb5ab7e651f9607ecee207891216714020b8ff081ef9"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1

  bottle do
    sha256 "48241043ff81ccd226d4303b11034ccdc636fd72aec2c5ba56398ef0191667d3" => :catalina
    sha256 "e76fd3f6fb11397c8963d6d92f8f6b56d19dc86ffcfdffb45663b50239f89a93" => :mojave
    sha256 "466948b3ed952a7ed22a41284ada218b5c007013670c799a54c23eff9ab15482" => :high_sierra
  end

  head do
    url "https://github.com/libvirt/libvirt.git"
    depends_on "meson" => :build
    depends_on "ninja" => :build
  end
  # remove build deps autoconf/automake/libtool in v6.7.0+
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "libtool" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "rpcgen" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "yajl"

  def install
    mkdir "build" do
      if build.head?
        args = %W[
          --localstatedir=#{var}
          --mandir=#{man}
          --sysconfdir=#{etc}
          -Ddriver_esx=enabled
          -Ddriver_qemu=enabled
          -Dinit_script=none
        ]
        system "meson", *std_meson_args, *args, ".."
        system "meson", "compile"
        system "meson", "install"
      else
        args = %W[
          --no-git
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

        args << "ac_cv_path_RPCGEN=#{Formula["rpcgen"].opt_prefix}/bin/rpcgen"

        # Work around a gnulib issue with macOS Catalina
        args << "gl_cv_func_ftello_works=yes"

        system "../autogen.sh", *args

        # Compilation of docs doesn't get done if we jump straight to "make install"
        system "make"
        system "make", "install"
      end
    end
  end

  plist_options manual: "libvirtd"

  def plist
    <<~EOS
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
            <string>-f</string>
            <string>#{etc}/libvirt/libvirtd.conf</string>
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
