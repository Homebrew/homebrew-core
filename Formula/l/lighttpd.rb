class Lighttpd < Formula
  desc "Small memory footprint, flexible web-server"
  homepage "https://www.lighttpd.net/"
  url "https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.82.tar.xz"
  sha256 "abfe74391f9cbd66ab154ea07e64f194dbe7e906ef4ed47eb3b0f3b46246c962"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?lighttpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0a5583c02185f8052e7eaffd66c71ce3664eade4870b67792aee5cbcd06d2805"
    sha256 arm64_sequoia: "06d7e74518bdfcf530d4f15663438cfb0d20146970099852ff6c3d4c3cbef1ab"
    sha256 arm64_sonoma:  "b7edf2907293e0e10e0498a4e6513d638cc1f6d2bf8ad169018835254d7a7938"
    sha256 sonoma:        "5713e25f7dd33f6817f865858544b5b534b491252574d75140ee3b2a37136080"
    sha256 arm64_linux:   "1289c89c548e955d6d8f689fe3738bdd3252890665aff75c43c65c819a4fd0de"
    sha256 x86_64_linux:  "b6c9e2497f72c7e635736d9dcd923c681cf0a0322d8ce45a2326b0a9506c1a2e"
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
