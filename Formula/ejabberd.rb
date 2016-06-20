class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"

  stable do
    url "https://www.process-one.net/downloads/ejabberd/16.04/ejabberd-16.04.tgz"
    sha256 "3d964fe74e438253c64c8498eb7465d2440823614a23df8d33bdf40126d72cc3"

    resource "lager" do
      url "https://github.com/basho/lager.git",
          :tag => "3.2.1",
          :revision => "8187757388c9adc915379caaab36a2f2ca26e944"
    end

    resource "p1_logger" do
      url "https://github.com/processone/p1_logger.git",
          :tag => "1.0.0",
          :revision => "bb8cfb9eca102197bfaaf34ce6c59cb296b7516f"
    end

    resource "p1_utils" do
      url "https://github.com/processone/p1_utils.git",
          :tag => "1.0.4",
          :revision => "e8d35fa5accd9a748bb8ac4942edcfa45be09ec3"
    end

    resource "cache_tab" do
      url "https://github.com/processone/cache_tab.git",
          :tag => "1.0.2",
          :revision => "aeb255793d1ca48a147d8b5f22c3bc09ddb6ba87"
    end

    resource "p1_tls" do
      url "https://github.com/processone/tls.git",
          :tag => "1.0.0",
          :revision => "f19e1f701e0a3980ffc70b3917c4aa85e68d8520"
    end

    resource "p1_stringprep" do
      url "https://github.com/processone/stringprep.git",
          :tag => "1.0.3",
          :revision => "5005ecbe503ae8b55d3ee81dc4e4db1193c216e2"
    end

    resource "p1_xml" do
      url "https://github.com/processone/xml.git",
          :tag => "1.1.2",
          :revision => "79c6d54e56bf991f1ec70ceb5e255afcb8dbf53f"
    end

    resource "p1_stun" do
      url "https://github.com/processone/stun.git",
          :tag => "1.0.3",
          :revision => "653943e6d0cc0f4803a9c3f014955f02f7b96bcd"
    end

    resource "esip" do
      url "https://github.com/processone/p1_sip.git",
          :tag => "1.0.1",
          :revision => "3bcccd4dfe705cb90f205887f749b1c5195fcad1"
    end

    resource "p1_yaml" do
      url "https://github.com/processone/p1_yaml.git",
          :tag => "1.0.1",
          :revision => "9109a7c4c18713999d0dc3a960d6d55c6f62b386"
    end

    resource "jiffy" do
      url "https://github.com/davisp/jiffy.git",
          :tag => "0.14.8",
          :revision => "1febce3ca86c5ca5d5a3618ed3d5f125bb99e4c5"
    end

    resource "oauth2" do
      url "https://github.com/kivra/oauth2.git",
          :revision => "218c963d387fafa16495bd50d62089b18fd28662"
    end

    resource "xmlrpc" do
      url "https://github.com/rds13/xmlrpc.git",
          :tag => "1.15",
          :revision => "9cd92b219ad97869d9da19ee4ea25ba1a40aea98"
    end

    resource "p1_mysql" do
      url "https://github.com/processone/mysql.git",
          :tag => "1.0.0",
          :revision => "064948ad3c77e582d85cbc09ccd11016ae97de0e"
    end

    resource "p1_pgsql" do
      url "https://github.com/processone/pgsql.git",
          :tag => "1.0.0",
          :revision => "248b6903cad82c748dc7f5be75e014dd8d47a3d1"
    end

    resource "sqlite3" do
      url "https://github.com/alexeyr/erlang-sqlite3.git",
          :revision => "7cf50f858975f9d493fdef2202c706240531caa1"
    end

    resource "p1_pam" do
      url "https://github.com/processone/epam.git",
          :tag => "1.0.0",
          :revision => "f0d6588f4733c4d8068af44cf51c966af8bf514a"
    end

    resource "p1_zlib" do
      url "https://github.com/processone/zlib.git",
          :tag => "1.0.0",
          :revision => "e1f928e61553cf85638eaac7d024c8f68ce0ff36"
    end

    resource "hamcrest" do
      url "https://github.com/hyperthunk/hamcrest-erlang.git",
          :revision => "908a24fda4a46776a5135db60ca071e3d783f9f6"
    end

    resource "riakc" do
      url "https://github.com/basho/riak-erlang-client.git",
          :tag => "2.1.2",
          :revision => "8c3256eba4468d7c56215d3f6b8af48634c1d4b1"
    end

    resource "elixir" do
      url "https://github.com/elixir-lang/elixir.git",
          :tag => "v1.2.6",
          :revision => "3dbfb92860fb24f83c92e1f1b67f48554fb211d6"
    end

    resource "rebar_elixir_plugin" do
      url "https://github.com/processone/rebar_elixir_plugin.git",
          :tag => "0.1.0",
          :revision => "10614dfef5d10b7071f7181858149259e50159f6"
    end

    resource "p1_iconv" do
      url "https://github.com/processone/eiconv.git",
          :tag => "0.9.0",
          :revision => "9751f86baa5a60ed1420490793e7514a0757462a"
    end

    resource "meck" do
      url "https://github.com/eproxus/meck.git",
          :tag => "0.8.4",
          :revision => "70d6a33ce7407029dc59e22a5b3c1c61c1348b23"
    end

    resource "eredis" do
      url "https://github.com/wooga/eredis.git",
          :tag => "v1.0.8",
          :revision => "cbc013f516e464706493c01662e5e9dd82d1db01"
    end
  end

  bottle do
    sha256 "8770ba2056ecc794a5aa8265784c9febe1ae0e95ad0c160649ff46fe625e3d82" => :el_capitan
    sha256 "c5210d8b0481ed205b9525e09aec741c037c99cf755586bfcfbb326f1ecbacb5" => :yosemite
    sha256 "b669c053987205cb897d18f3b0640c20f54e511aa54d37666e69582dbb6f90b6" => :mavericks
  end

  head do
    url "https://github.com/processone/ejabberd.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build

    resource "cache_tab" do
      url "https://github.com/processone/cache_tab.git",
        :tag => "1.0.1", :revision => "26caea06c72c2117ca54d04beedb5b49a45af1a8"
    end

    resource "p1_tls" do
      url "https://github.com/processone/tls.git"
    end

    resource "p1_stringprep" do
      url "https://github.com/processone/stringprep.git"
    end

    resource "p1_xml" do
      url "https://github.com/processone/xml.git"
    end

    resource "esip" do
      url "https://github.com/processone/p1_sip.git"
    end

    resource "p1_stun" do
      url "https://github.com/processone/stun.git"
    end

    resource "p1_yaml" do
      url "https://github.com/processone/p1_yaml.git"
    end

    resource "p1_utils" do
      url "https://github.com/processone/p1_utils.git"
    end

    resource "jiffy" do
      url "https://github.com/davisp/jiffy.git"
    end

    resource "p1_mysql" do
      url "https://github.com/processone/mysql.git"
    end

    resource "p1_pgsql" do
      url "https://github.com/processone/pgsql.git"
    end

    resource "sqlite" do
      url "https://github.com/alexeyr/erlang-sqlite3.git"
    end

    resource "p1_pam" do
      url "https://github.com/processone/epam.git"
    end

    resource "p1_zlib" do
      url "https://github.com/processone/zlib.git"
    end

    resource "riakc" do
      url "https://github.com/basho/riak-erlang-client.git"
    end

    resource "rebar_elixir_plugin" do
      url "https://github.com/processone/rebar_elixir_plugin.git"
    end

    resource "elixir" do
      url "https://github.com/elixir-lang/elixir.git"
    end

    resource "p1_iconv" do
      url "https://github.com/processone/eiconv.git"
    end

    resource "lager" do
      url "https://github.com/basho/lager.git"
    end

    resource "p1_logger" do
      url "https://github.com/processone/p1_logger.git"
    end

    resource "meck" do
      url "https://github.com/eproxus/meck.git"
    end

    resource "eredis" do
      url "https://github.com/wooga/eredis.git"
    end

    resource "oauth2" do
      url "https://github.com/prefiks/oauth2.git"
    end

    resource "xmlrpc" do
      url "https://github.com/rds13/xmlrpc.git"
    end
  end

  option "32-bit"

  depends_on "openssl"
  depends_on "erlang"
  depends_on "libyaml"
  # for CAPTCHA challenges
  depends_on "imagemagick" => :optional

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    if build.build_32_bit?
      ENV.append %w[CFLAGS LDFLAGS], "-arch #{Hardware::CPU.arch_32_bit}"
    end

    deps_file = "rebar.config"

    resources.each do |r|
      r.fetch
      r.url =~ %r{github\.com/([^/]+)/(.+?)\.git$}
      user = $1
      repo = $2

      inreplace deps_file,
        # match https://github.com, git://github.com, and git@github
        %r{(?:https://|git(?:://|@))github\.com[:/]#{user}/#{repo}(?:\.git)?},
        r.cached_download
    end

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--enable-pgsql",
            "--enable-mysql",
            "--enable-odbc",
            "--enable-pam",
           ]

    system "./autogen.sh" if build.head?
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
