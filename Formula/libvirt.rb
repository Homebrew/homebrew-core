class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-6.8.0.tar.xz"
  sha256 "0c2d7f6ed8bc4956bf7f0c8ca2897c6c82ddb91e3118ab7a588b25eedd16ef69"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?([\d.]+)\.t/i)
  end

  bottle do
    sha256 "11960b9158da8591ea8deb2099f4ab4db9466e9a10b42f9f8b49affa8abba086" => :catalina
    sha256 "3286f6941d6cf23468906cf1e628714b860487f44bb26d6f62d89701878d510d" => :mojave
    sha256 "2ece1e584d23edf04c7aec70cd9a8586484aeb4fad0887886c8fe5b1d2505f67" => :high_sierra
  end

  head do
    url "https://github.com/libvirt/libvirt.git"
  end
  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "rpcgen" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libiscsi"
  depends_on "libssh2"
  depends_on "yajl"

  def install
    mkdir "build" do
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
