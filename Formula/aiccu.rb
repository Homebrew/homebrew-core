class Aiccu < Formula
  desc "Automatic IPv6 Connectivity Client Utility"
  homepage "https://www.sixxs.net/tools/aiccu/"
  url "https://deb.debian.org/debian/pool/main/a/aiccu/aiccu_20070115.orig.tar.gz"
  mirror "http://ports.ubuntu.com/ubuntu-ports/pool/universe/a/aiccu/aiccu_20070115.orig.tar.gz"
  version "20070115"
  sha256 "d23cf50a16fa842242c97683c3c1c1089a7a4964e3eaba97ad1f17110fdfe3cc"

  bottle do
    rebuild 1
    sha256 "83284f72e078fceac87aee5752547ea4d25c6be0421a9bc3cd64bb97177b8ea7" => :catalina
    sha256 "f6c90e2ecdcd0d676abe4fb32f98a8592d348ac3794de62fa64f403e5ecbbf17" => :mojave
    sha256 "9033bb99bd8fbaa3b74abb0fa850b2220c317628851af361180c0c764732d49c" => :high_sierra
    sha256 "ee19bef55805a8562bddb41a3af66e5bce9589b1e4d96b05348a37b5ada2c091" => :sierra
    sha256 "572e103e9de9c872eb202e18d5c4f352f0b9dc26d284d5979b83ff6fa3daa5b2" => :el_capitan
    sha256 "e4db05626f082c10398f46ac40aa25ec271be6e4372330d6d7c27b2349d0e789" => :yosemite
  end

  # Patches per MacPorts
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/aiccu/20070115.patch"
    sha256 "08b0c9c4fe6349e4a826fe813b966848f01832de8bbfe3f9807b8742de6578df"
  end

  def install
    inreplace "doc/aiccu.conf", "daemonize true", "daemonize false"
    system "make", "prefix=#{prefix}"
    system "make", "install", "prefix=#{prefix}"

    etc.install "doc/aiccu.conf"
  end

  def caveats
    <<~EOS
      You may also wish to install tuntap:

        The TunTap project provides kernel extensions for macOS that allow
        creation of virtual network interfaces.

        https://tuntaposx.sourceforge.io/

      You can install tuntap with homebrew using brew install tuntap

      Unless it exists already, a aiccu.conf file has been written to:
        #{etc}/aiccu.conf

      Protect this file as it will contain your credentials.

      The 'aiccu' command will load this file by default unless told to use
      a different one.
    EOS
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/aiccu</string>
        <string>start</string>
        <string>#{etc}/aiccu.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{sbin}/aiccu", "version"
  end
end
