class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://static.process-one.net/ejabberd/downloads/21.04/ejabberd-21.04.tgz"
  sha256 "7dc2797b3223bc92f422ee35f53a1cf686a738c99641b87768b519d8c3bfb73a"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e724d35c5572f8c4b4249b4986cfd9641af633c0498247f098b2d84391ecb52f"
    sha256 cellar: :any, big_sur:       "48160b33cfecd42b409ab92d25301ce7136dd95afbef0ff81ea7ed356030bc71"
    sha256 cellar: :any, catalina:      "9d168b77adb8fefc6859d7fbad6478c7faaf3aa395d71bd46e3865bcd85407a5"
    sha256 cellar: :any, mojave:        "adfbcb57cc672dca1db1b09e1b08b20736a5ab17e361f8d50352c065b9b643d2"
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

  conflicts_with "couchdb", because: "both install `jiffy` lib"

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

    # Create the vm.args file, if it does not exist. Put a random cookie in it to secure the instance.
    vm_args_file = etc/"ejabberd/vm.args"
    unless vm_args_file.exist?
      require "securerandom"
      cookie = SecureRandom.hex
      vm_args_file.write <<~EOS
        -setcookie #{cookie}
      EOS
    end
  end

  def caveats
    <<~EOS
      If you face nodedown problems, concat your machine name to:
        /private/etc/hosts
      after 'localhost'.
    EOS
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/sbin/ejabberdctl start"

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
