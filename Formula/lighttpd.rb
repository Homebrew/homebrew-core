class Lighttpd < Formula
  desc "Small memory footprint, flexible web-server"
  homepage "https://www.lighttpd.net/"
  url "https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.63.tar.xz"
  sha256 "2aef7f0102ebf54a1241a1c3ea8976892f8684bfb21697c9fffb8de0e2d6eab9"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://download.lighttpd.net/lighttpd/releases-1.4.x/"
    regex(/href=.*?lighttpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ac2231f844afae0a9f19eec7fe218cc2464ad872d52ba26cfcd11335501ce0a7"
    sha256 arm64_big_sur:  "8c428e23989126dcaf38dc6cc1ffe10c9a6099cce0ca93d011de61d43ed04928"
    sha256 monterey:       "80ba67158d72a6517df08a4a8c9f88108e05d014fffe2acc3524a02b405fb3b0"
    sha256 big_sur:        "1deefed2b413575a107a8aa28597221197945a2707d0fa00d243c7b8cfb23e31"
    sha256 catalina:       "ad0bd2601b5fe42ef3cca5af694c03fc4df9f2fea76b54dbaf72f64254ba9062"
    sha256 x86_64_linux:   "3909172c937696725005c3d8ce36df9c7715c4f925564a137d57a33b0b9b5ab5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openldap"
  depends_on "openssl@1.1"
  depends_on "pcre2"

  # default max. file descriptors; this option will be ignored if the server is not started as root
  MAX_FDS = 512

  def config_path
    etc/"lighttpd"
  end

  def log_path
    var/"log/lighttpd"
  end

  def www_path
    var/"www"
  end

  def run_path
    var/"lighttpd"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sbindir=#{bin}
      --with-bzip2
      --with-ldap
      --with-openssl
      --without-pcre
      --with-pcre2
      --with-zlib
    ]

    # autogen must be run, otherwise prebuilt configure may complain
    # about a version mismatch between included automake and Homebrew's
    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

    unless File.exist? config_path
      config_path.install "doc/config/lighttpd.conf", "doc/config/modules.conf"
      (config_path/"conf.d/").install Dir["doc/config/conf.d/*.conf"]
      inreplace config_path+"lighttpd.conf" do |s|
        s.sub!(/^var\.log_root\s*=\s*".+"$/, "var.log_root    = \"#{log_path}\"")
        s.sub!(/^var\.server_root\s*=\s*".+"$/, "var.server_root = \"#{www_path}\"")
        s.sub!(/^var\.state_dir\s*=\s*".+"$/, "var.state_dir   = \"#{run_path}\"")
        s.sub!(/^var\.home_dir\s*=\s*".+"$/, "var.home_dir    = \"#{run_path}\"")
        s.sub!(/^var\.conf_dir\s*=\s*".+"$/, "var.conf_dir    = \"#{config_path}\"")
        s.sub!(/^server\.port\s*=\s*80$/, "server.port = 8080")
        s.sub!(%r{^server\.document-root\s*=\s*server_root \+ "/htdocs"$}, "server.document-root = server_root")

        # get rid of "warning: please use server.use-ipv6 only for hostnames, not
        # without server.bind / empty address; your config will break if the kernel
        # default for IPV6_V6ONLY changes"
        s.sub!(/^server.use-ipv6\s*=\s*"enable"$/, 'server.use-ipv6 = "disable"')

        s.sub!(/^server\.username\s*=\s*".+"$/, 'server.username  = "_www"')
        s.sub!(/^server\.groupname\s*=\s*".+"$/, 'server.groupname = "_www"')
        s.sub!(/^#server\.network-backend\s*=\s*"sendfile"$/, 'server.network-backend = "writev"')

        # "max-connections == max-fds/2",
        # https://redmine.lighttpd.net/projects/1/wiki/Server_max-connectionsDetails
        s.sub!(/^#server\.max-connections = .+$/, "server.max-connections = " + (MAX_FDS / 2).to_s)
      end
    end

    log_path.mkpath
    (www_path/"htdocs").mkpath
    run_path.mkpath
  end

  def caveats
    <<~EOS
      Docroot is: #{www_path}

      The default port has been set in #{config_path}/lighttpd.conf to 8080 so that
      lighttpd can run without sudo.
    EOS
  end

  plist_options manual: "lighttpd -f #{HOMEBREW_PREFIX}/etc/lighttpd/lighttpd.conf"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/lighttpd</string>
          <string>-D</string>
          <string>-f</string>
          <string>#{config_path}/lighttpd.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{log_path}/output.log</string>
        <key>StandardOutPath</key>
        <string>#{log_path}/output.log</string>
        <key>HardResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>#{MAX_FDS}</integer>
        </dict>
        <key>SoftResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>#{MAX_FDS}</integer>
        </dict>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/lighttpd", "-t", "-f", config_path/"lighttpd.conf"
  end
end
