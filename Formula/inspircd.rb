class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v2.0.24.tar.gz"
  sha256 "41f702cb84caa2db089a02f511a3da3e7fa3cdce7d2c5040b3c54c5da83c8b40"
  head "https://github.com/inspircd/inspircd.git", :branch => "insp20"

  bottle do
    sha256 "82cc4e1ac89c8e5187732eec5173dcfc22472cc8db02ee4e4f2e38d7af1c510e" => :sierra
    sha256 "399ef38bf73da815b8474922013136e85045f1e8d060fb8e01ecf9eb2b84c9d4" => :el_capitan
    sha256 "1fc8066a11d1fcf5abf24f591e85ef154309aa745b02c58555b2d73d1f4c6b66" => :yosemite
    sha256 "2b20e89558b7bfb41ce8a0c559ed5de1e54ce3259736c36bfd18c1a03f0e12cb" => :mavericks
  end

  skip_clean "data"
  skip_clean "logs"

  option "without-ldap", "Build without ldap support"

  depends_on "pkg-config" => :build
  depends_on "geoip" => :optional
  depends_on "gnutls" => :optional
  depends_on :mysql => :optional
  depends_on "openssl" => :optional
  depends_on "pcre" => :optional
  depends_on "postgresql" => :optional
  depends_on "sqlite" => :optional
  depends_on "tre" => :optional

  def install
    modules = []
    modules << "m_geoip.cpp" if build.with? "geoip"
    modules << "m_ssl_gnutls.cpp" if build.with? "gnutls"
    modules << "m_mysql.cpp" if build.with? "mysql"
    modules << "m_ssl_openssl.cpp" if build.with? "openssl"
    modules << "m_ldapauth.cpp" << "m_ldapoper.cpp" if build.with? "ldap"
    modules << "m_regex_pcre.cpp" if build.with? "pcre"
    modules << "m_pgsql.cpp" if build.with? "postgresql"
    modules << "m_sqlite3.cpp" if build.with? "sqlite"
    modules << "m_regex_tre.cpp" if build.with? "tre"

    system "./configure", "--enable-extras=#{modules.join(",")}" unless modules.empty?
    system "./configure", "--prefix=#{prefix}", "--with-cc=#{ENV.cc}"
    system "make", "install"
  end

  def post_install
    inreplace "#{prefix}/org.inspircd.plist", "ircdaemon", ENV["USER"]
  end

  test do
    system "#{bin}/inspircd", "--version"
  end
end
