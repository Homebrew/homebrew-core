class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://www.process-one.net/downloads/ejabberd/18.06/ejabberd-18.06.tgz"
  sha256 "ac9dbe8b58aec5403ecfe48cb90f11e7f55664185094bac94615c6c9323690b0"

  bottle do
    sha256 "9f9b034d58cea40f3da6b2ddc750cbebcc20e4a60fdc108d978ac513be394651" => :high_sierra
    sha256 "eebf922658e9075b48c39802f41ced1a0fff2e6bf084c798c0a8966dd91135ec" => :sierra
    sha256 "e8c9f05d90035141be73d1042fd3704ea9db3a850559e3935681a4a6b23f4409" => :el_capitan
  end

  head do
    url "https://github.com/processone/ejabberd.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "openssl"
  depends_on "erlang"
  depends_on "gd"
  depends_on "libyaml"
  # for CAPTCHA challenges
  depends_on "imagemagick" => :optional

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--enable-pgsql",
            "--enable-mysql",
            "--enable-odbc",
            "--enable-pam"]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"

    ENV.deparallelize
    system "make", "install"

    (etc/"ejabberd").mkpath
  end

  def post_install
    (var/"lib/ejabberd").mkpath
    (var/"spool/ejabberd").mkpath
  end

  def caveats; <<~EOS
    If you face nodedown problems, concat your machine name to:
      /private/etc/hosts
    after 'localhost'.
  EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/ejabberdctl start"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>EnvironmentVariables</key>
      <dict>
        <key>HOME</key>
        <string>#{var}/lib/ejabberd</string>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/ejabberdctl</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/lib/ejabberd</string>
    </dict>
    </plist>
  EOS
  end

  test do
    system sbin/"ejabberdctl", "ping"
  end
end
