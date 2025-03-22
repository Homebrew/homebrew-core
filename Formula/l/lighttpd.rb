class Lighttpd < Formula
  desc "Small memory footprint, flexible web-server"
  homepage "https://www.lighttpd.net/"
  url "https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.77.tar.xz"
  sha256 "acafabdbfa2267d8b6452d03d85fdd2a66525f3f05a36a79b6645c017f1562ce"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?lighttpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ea181efeede65837d89e175b9655334c6324bef636685079a16280734cf99cd1"
    sha256 arm64_sonoma:  "bfb037e447da708a32a4b863d339c1a41b48af809ca6a47da1510d7b28d0efd7"
    sha256 arm64_ventura: "853dff40ff89429e50a349b1c595fcd130e175b2a409f21ceb9542afe06b940c"
    sha256 sonoma:        "85fb623779424c20ac74ca7559a56f9315ee1573acb1d110512a335dd536d8c5"
    sha256 ventura:       "3e0178fa9120a7a92e49dea1bd4815e17408fe8c5d16838b5a811fb3c118b122"
    sha256 arm64_linux:   "f9720eac9aa4eb7b22637e01a79327e5c6dd65f1d45493cbc6c99c7e9be6e8da"
    sha256 x86_64_linux:  "91b5e99bae350afd3df2dc183c42c81cba441a64f9488af7e3866ad7fe55c135"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openldap"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  # default max. file descriptors; this option will be ignored if the server is not started as root
  MAX_FDS = 512

  def install
    args = %W[
      --disable-silent-rules
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
    system "./configure", *args, *std_configure_args
    system "make", "install"

    unless File.exist? etc/"lighttpd"
      (etc/"lighttpd").install "doc/config/lighttpd.conf", "doc/config/lighttpd.annotated.conf",
        "doc/config/modules.conf"
      (etc/"lighttpd/conf.d/").install Dir["doc/config/conf.d/*.conf"]
      inreplace etc + "lighttpd/lighttpd.annotated.conf" do |s|
        s.sub!(/^var\.log_root\s*=\s*".+"$/, "var.log_root    = \"#{var}/log/lighttpd\"")
        s.sub!(/^var\.server_root\s*=\s*".+"$/, "var.server_root = \"#{var}/www\"")
        s.sub!(/^var\.state_dir\s*=\s*".+"$/, "var.state_dir   = \"#{var}/lighttpd\"")
        s.sub!(/^var\.home_dir\s*=\s*".+"$/, "var.home_dir    = \"#{var}/lighttpd\"")
        s.sub!(/^var\.conf_dir\s*=\s*".+"$/, "var.conf_dir    = \"#{etc}/lighttpd\"")
        s.sub!(/^#server\.port\s*=\s*80$/, "server.port = 8080")
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
    system bin/"lighttpd", "-t", "-f", etc/"lighttpd/lighttpd.conf"
  end
end
