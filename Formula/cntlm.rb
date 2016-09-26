class Cntlm < Formula
  desc "NTLM authentication proxy with tunneling"
  homepage "http://cntlm.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3.tar.bz2"
  sha256 "7b603d6200ab0b26034e9e200fab949cc0a8e5fdd4df2c80b8fc5b1c37e7b930"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcf5fe29a8a0853aa34f48f88c16666d163ace489623b2cf04cace23d993d392" => :sierra
    sha256 "9e53cf019ca2408b0d5e1a688bdd78ee785ec36501488ecb63caca9bfc53dd70" => :el_capitan
    sha256 "b36b8286f391a05a3a3dc2b450f5157d1c5c69b01683a0133a566c77eaa87e39" => :yosemite
    sha256 "6e20a8381c8411c02a39c8e880660040f71d55acc795c71802ef3afcccbdfaf1" => :mavericks
  end

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "SYSCONFDIR=#{etc}"
    # install target fails - @adamv
    bin.install "cntlm"
    man1.install "doc/cntlm.1"
    etc.install "doc/cntlm.conf"
  end

  def caveats
    "Edit #{etc}/cntlm.conf to configure Cntlm"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/cntlm</string>
          <string>-f</string>
        </array>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end
end
