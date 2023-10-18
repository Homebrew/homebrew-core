class Lighttpd < Formula
  desc "Small memory footprint, flexible web-server"
  homepage "https://www.lighttpd.net/"
  url "https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.72.tar.xz"
  sha256 "f7cade4d69b754a0748c01463c33cd8b456ca9cc03bb09e85a71bcbcd54e55ec"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?lighttpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "36dd8f56a599dad9c6dfe3c1034fb58f0356e61866d6201a6410df1b4832e512"
    sha256 arm64_ventura:  "48874cc605911b3b9aefc9d0ceff622972641fc0af3482041ca40f3b563a0e6a"
    sha256 arm64_monterey: "894260a4b658cab53d0197944169dc7efe295cc79a2a3bb200122d2b8767f18b"
    sha256 sonoma:         "a85c1239d70506cdf7991195187b41c9f3573eb84c4719c7e35573ccd1d506bb"
    sha256 ventura:        "af23c4efba2b9f4a86d356949434ab57805b5333d2c34aeb022accbeb1b5d2cf"
    sha256 monterey:       "bf4b6107f691e193fac8fd7ca4593206b540e7364136ba360fdf3961befcedea"
    sha256 x86_64_linux:   "a4a990801a919d6517c1e962760058e60e34c0cfe5b7c5a9f60f6cc608791b0c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openldap"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  # default max. file descriptors; this option will be ignored if the server is not started as root
  MAX_FDS = 512

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

    unless File.exist? etc/"lighttpd"
      (etc/"lighttpd").install "doc/config/lighttpd.conf", "doc/config/modules.conf"
      (etc/"lighttpd/conf.d/").install Dir["doc/config/conf.d/*.conf"]
      inreplace etc + "lighttpd/lighttpd.conf" do |s|
        s.sub!(/^var\.log_root\s*=\s*".+"$/, "var.log_root    = \"#{var}/log/lighttpd\"")
        s.sub!(/^var\.server_root\s*=\s*".+"$/, "var.server_root = \"#{var}/www\"")
        s.sub!(/^var\.state_dir\s*=\s*".+"$/, "var.state_dir   = \"#{var}/lighttpd\"")
        s.sub!(/^var\.home_dir\s*=\s*".+"$/, "var.home_dir    = \"#{var}/lighttpd\"")
        s.sub!(/^var\.conf_dir\s*=\s*".+"$/, "var.conf_dir    = \"#{etc}/lighttpd\"")
        s.sub!(/^server\.port\s*=\s*80$/, "server.port = 8080")
        s.sub!(%r{^server\.document-root\s*=\s*server_root \+ "/htdocs"$}, "server.document-root = server_root")

        s.sub!(/^server\.username\s*=\s*".+"$/, 'server.username  = "_www"')
        s.sub!(/^server\.groupname\s*=\s*".+"$/, 'server.groupname = "_www"')
        s.sub!(/^#server\.network-backend\s*=\s*"sendfile"$/, 'server.network-backend = "writev"')

        # "max-connections == max-fds/2",
        # https://redmine.lighttpd.net/projects/1/wiki/Server_max-connectionsDetails
        s.sub!(/^#server\.max-connections = .+$/, "server.max-connections = " + (MAX_FDS / 2).to_s)
      end
    end

    (var/"log/lighttpd").mkpath
    (var/"www/htdocs").mkpath
    (var/"lighttpd").mkpath
  end

  def caveats
    <<~EOS
      Docroot is: #{var}/www

      The default port has been set in #{etc}/lighttpd/lighttpd.conf to 8080 so that
      lighttpd can run without sudo.
    EOS
  end

  service do
    run [opt_bin/"lighttpd", "-D", "-f", etc/"lighttpd/lighttpd.conf"]
    keep_alive false
    error_log_path var/"log/lighttpd/output.log"
    log_path var/"log/lighttpd/output.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/lighttpd", "-t", "-f", etc/"lighttpd/lighttpd.conf"
  end
end
