class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.3/dovecot-2.3.2.1.tar.gz"
  sha256 "4a65118508dc7a562e5f90dd7c3f56219fff22367c496f17d77cd0c7e2724e34"

  bottle do
    sha256 "63acd1b4cb9da5efb409656601b5c50b08b4ca8bf026e0b75110e3d2cda123d4" => :mojave
    sha256 "a65b0489355543c50a65eff854b5bdbc1ea79246517eea0a49c97617a22edff5" => :high_sierra
    sha256 "182a940de84e95f3ddf06746c28b616412417d9684d100b1d03ea90991ae5517" => :sierra
    sha256 "0ea8bb9c76d54244d97a8ef135c98b9321be68c1bf3ff0ddfea1d1080f55c01a" => :el_capitan
  end

  option "with-pam", "Build with PAM support"
  option "with-pigeonhole", "Add Sieve addon for Dovecot mailserver"

  depends_on "openssl"

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.2.tar.gz"
    sha256 "950e8e15c58e539761255e140dd3678dd2477fa432a5f2b804e53821bdc02535"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-sqlite
      --with-ssl=openssl
      --with-zlib
    ]

    args << "--with-pam" if build.with? "pam"

    system "./configure", *args
    system "make", "install"

    if build.with? "pigeonhole"
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
