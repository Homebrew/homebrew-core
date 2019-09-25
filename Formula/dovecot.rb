class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.3/dovecot-2.3.7.2.tar.gz"
  sha256 "666ce084760a47e601d49a9be3c7993c48789d332631e8dfb45f443b367b1260"

  bottle do
    sha256 "6ffa465af013882828655b0c290b83611b172787299b6dbe064198819fd16f57" => :mojave
    sha256 "a4e7c81233500b6d60f0c26f2208d6d8db3a17f206143a35e3d534cb5ea53dc4" => :high_sierra
    sha256 "aef15a20ff625341dc46236388ec310ece8fc6592623341ee71956c1efe4e577" => :sierra
  end

  depends_on "openssl@1.1"

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.7.2.tar.gz"
    sha256 "d59d0c5c5225a126e5b98bf95d75e8dd368bdeeb3da2e9766dbe4fddaa9411b0"
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
