class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://www.process-one.net/downloads/ejabberd/20.02/ejabberd-20.02.tgz"
  sha256 "70d3f1f11ee1d68de7944b879fd502595a4b64e379073986ae5613f774a9d0b9"

  bottle do
    cellar :any
    sha256 "aa28c86c26a48f1e5bf1138add19cdbb8b6b07a5fab9e3d35beda6969aa9b020" => :catalina
    sha256 "d5dd3cd458519ee5f531c5000e308112f5ad1366fc7c250260db5c3628393c8f" => :mojave
    sha256 "68e0a18b7a0cb4a3a9952f1698f91cd071ebca3660f8c62c42b3b81750be7501" => :high_sierra
  end

  head do
    url "https://github.com/processone/ejabberd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "erlang"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@1.1"

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
