class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-6.10.0.tar.xz"
  sha256 "30cfc1365b7a62bf08c5254103087fac51c4210343aa958a7d38cedd280ed2aa"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?([\d.]+)\.t/i)
  end

  bottle do
    sha256 "0691fb2e0adb30adb37933107a1ac5c34f01656438fa6840dd650fa63ebf93f6" => :big_sur
    sha256 "e28aaebcf0a86ae8e2906bbd0c228abbe86512184d6d82be01f98e10acc9a2ba" => :catalina
    sha256 "178e78989b00690c1407d6c2e31703040dc69b7a0af096c18d95619fdedf4136" => :mojave
  end

  head do
    url "https://github.com/libvirt/libvirt.git"
    patch do 
      url "https://gist.githubusercontent.com/m-bers/656d736686ebc240d76407ebdd4221f6/raw/3d923b8c5f029d992d6d69119a96ff3f4018ba38/cpu_arm_m1.patch"
    end
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
