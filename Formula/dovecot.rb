class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.3/dovecot-2.3.1.tar.gz"
  sha256 "0883821b97fd02a084a84b9469a681f7e6edc56541d854b5419d98891c51fb93"

  bottle do
    sha256 "45f1715564e702c8219d24089b09b526582cac66fbba92b64a0a3a7ad6fb8adf" => :high_sierra
    sha256 "99ba590650def35c3fc895f768fdcb28095fd9297d47040801383e8314ceff62" => :sierra
    sha256 "655ad80916e6f404014e9338ee691b053eb245dd5719adfffe75ddb82d6d1e83" => :el_capitan
  end

  option "with-pam", "Build with PAM support"
  option "with-pigeonhole", "Add Sieve addon for Dovecot mailserver"
  option "with-pigeonhole-unfinished-features", "Build unfinished new Sieve addon features/extensions"
  option "with-stemmer", "Build with libstemmer support"

  depends_on "openssl"
  depends_on "clucene" => :optional

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.1.tar.gz"
    sha256 "e3b0aa59261881bcb0d33a6c398f3cb5f9f75e077e67bae175cf33c362577547"
  end

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
        :revision => "16f059b827d0d2bd10746a3b3cfbde2fd102bf05"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-ssl=openssl
      --with-sqlite
      --with-zlib
      --with-bzlib
    ]

    args << "--with-lucene" if build.with? "clucene"
    args << "--with-pam" if build.with? "pam"

    if build.with? "stemmer"
      args << "--with-libstemmer"

      resource("stemmer").stage do
        system "make", "dist_libstemmer_c"
        system "tar", "xzf", "dist/libstemmer_c.tgz", "-C", buildpath
      end
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "pigeonhole"
      resource("pigeonhole").stage do
        args = %W[
          --disable-dependency-tracking
          --with-dovecot=#{lib}/dovecot
          --prefix=#{prefix}
        ]

        args << "--with-unfinished-features" if build.with? "pigeonhole-unfinished-features"

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
