class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://static.process-one.net/ejabberd/downloads/21.07/ejabberd-21.07.tgz"
  sha256 "0e90cfd6c03191ca8aef344b9d543a038e272770be14c2288d83cc4d34825868"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_monterey: "4b54e5246a1a00c93856d1786eb4067b3883f4293d3fb91a7345441fdc90ba76"
    sha256 cellar: :any, arm64_big_sur:  "c22a2bd2a9dfcbbdc1e6df1ea63ae25924234f1ddd4cb5f4b016fc2013b97487"
    sha256 cellar: :any, monterey:       "0e7930fc896f7e8136ed435743502e88820d1463a850537190b3d993aed6f202"
    sha256 cellar: :any, big_sur:        "61ae3c224f34b18973bca8c311cdf990fe4e1c2be444d69ae5f9e2ecab6984b2"
    sha256 cellar: :any, catalina:       "e864b717afec626c0a2b1e1038c1dcef082f6ef34d72085581f594d77b7a0ad1"
    sha256 cellar: :any, mojave:         "8856dec9f546db393d17f66ec8427e0429650658e2622cad22f47347b563495b"
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
