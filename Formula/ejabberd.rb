class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"

  stable do
    url "https://www.process-one.net/downloads/ejabberd/16.04/ejabberd-16.04.tgz"
    sha256 "3d964fe74e438253c64c8498eb7465d2440823614a23df8d33bdf40126d72cc3"
  end

  bottle do
    sha256 "8770ba2056ecc794a5aa8265784c9febe1ae0e95ad0c160649ff46fe625e3d82" => :el_capitan
    sha256 "c5210d8b0481ed205b9525e09aec741c037c99cf755586bfcfbb326f1ecbacb5" => :yosemite
    sha256 "b669c053987205cb897d18f3b0640c20f54e511aa54d37666e69582dbb6f90b6" => :mavericks
  end

  head do
    url "https://github.com/processone/ejabberd.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "elixir"
  depends_on "erlang"
  depends_on "expat"
  depends_on "libiconv"
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "sqlite"

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    args = ["--prefix=#{prefix}",
            "--bindir=#{prefix}/ebin",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--enable-all",
           ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"

    (etc/"ejabberd").mkpath
    (var/"lib/ejabberd").mkpath
    (var/"spool/ejabberd").mkpath
  end

  def caveats; <<-EOS.undent
    If you face nodedown problems, concat your machine name to:
      /private/etc/hosts
    after 'localhost'.
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/ejabberdctl start"

  def plist; <<-EOS.undent
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
    system "#{sbin}/ejabberdctl", "ping"
  end
end
