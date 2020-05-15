class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://static.process-one.net/ejabberd/downloads/20.04/ejabberd-20.04.tgz"
  sha256 "130673a835a9768a47c78c6bfe9c622a3b5916dd8aaf12aad0acd2d0f7f3a5cf"
  revision 1

  bottle do
    cellar :any
    sha256 "997235f90e98b5b2ca80b4a7412cb4742103b4cd87c16a241aff1f63b2ebb13a" => :catalina
    sha256 "991fee58cc52c71dc5591349e07799c569dde5120eef02a4717a3bb9f9f5d513" => :mojave
    sha256 "c23057a68ad47f6210997380e25c2bc9e45a4526e4fa69917964958011bc06c7" => :high_sierra
  end

  head do
    url "https://github.com/processone/ejabberd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "erlang@22"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@1.1"

  conflicts_with "couchdb", :because => "both install `jiffy` lib"

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

    # Set CPP to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    system "make", "CPP=clang -E"

    ENV.deparallelize
    system "make", "install"

    (etc/"ejabberd").mkpath
  end

  def post_install
    (var/"lib/ejabberd").mkpath
    (var/"spool/ejabberd").mkpath
  end

  def caveats
    <<~EOS
      If you face nodedown problems, concat your machine name to:
        /private/etc/hosts
      after 'localhost'.
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/ejabberdctl start"

  def plist
    <<~EOS
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
