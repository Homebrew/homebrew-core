class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://www.process-one.net/downloads/ejabberd/18.04/ejabberd-18.04.tgz"
  sha256 "fa2a754e482ed90976d2bdd59ac438bdf08313e9a84a1d9f7a5d768617d7e85a"

  bottle do
    sha256 "51e4b5ec56674844bf385ec14dabb3e5cf338d24960e9e35daa9c62436c41b93" => :high_sierra
    sha256 "9eafe8585cb38b7a70a8608010a8191f1c9c1a9da975e3d8332d7751e095df75" => :sierra
    sha256 "bd8ab1e7b90c84deb8f383e2a10b8a40c95e4903a40f866505678ff8947968ab" => :el_capitan
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
