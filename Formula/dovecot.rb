class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://www.dovecot.org/releases/2.3/dovecot-2.3.5.1.tar.gz"
  sha256 "d78f9d479e3b2caa808160f86bfec1c9c7b46344d8b14b88f5fa9bbbf8c7c33f"

  bottle do
    sha256 "8e8b2cbf26ef7760b20a012247ccd495cfcb28312776f5889c261ed93409d74e" => :mojave
    sha256 "e80b3088c9bb8081bdd39fcd269cb68353f356bb0520f97d787ab621bf35ae43" => :high_sierra
    sha256 "d9fd6d64dc1910ea166801939754e8dce929f2f645d12f148cc1eb98978600fb" => :sierra
  end

  depends_on "openssl"

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.5.tar.gz"
    sha256 "cbaa106e1c2b23824420efdd6a9f8572c64c8dccf75a3101a899b6ddb25149a5"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-pam
      --with-sqlite
      --with-ssl=openssl
      --with-zlib
    ]

    system "./configure", *args
    system "make", "install"

    resource("pigeonhole").stage do
      args = %W[
        --disable-dependency-tracking
        --with-dovecot=#{lib}/dovecot
        --prefix=#{prefix}
      ]

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    For Dovecot to work, you may need to create a dovecot user
    and group depending on your configuration file options.
  EOS
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dovecot</string>
          <string>-F</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/dovecot/dovecot.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/dovecot/dovecot.log</string>
        <key>SoftResourceLimits</key>
        <dict>
        <key>NumberOfFiles</key>
        <integer>1000</integer>
        </dict>
        <key>HardResourceLimits</key>
        <dict>
        <key>NumberOfFiles</key>
        <integer>1024</integer>
        </dict>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dovecot --version")
  end
end
