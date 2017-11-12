class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v2.0.25.tar.gz"
  sha256 "c2488fafd04fcabbd8ddc8b9cdc6e0b57e942802b451c9cbccaf5d8483ebd251"
  head "https://github.com/inspircd/inspircd.git", :branch => "insp20"

  bottle do
    sha256 "fa0c21347636bbcf3cdb50606bc993607a705d6fc740d7af61c3d637af21aa42" => :high_sierra
    sha256 "cb4476a4883acb2a5d6aac17d7f8879fe1938ce34e8d37d97e5761e74ac4ce50" => :sierra
    sha256 "b73cab6e0683569ce510aff2f6817174e1986d2fa468bf344c812222cfc0b7f7" => :el_capitan
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
