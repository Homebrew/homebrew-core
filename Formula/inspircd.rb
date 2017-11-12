class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v2.0.25.tar.gz"
  sha256 "c2488fafd04fcabbd8ddc8b9cdc6e0b57e942802b451c9cbccaf5d8483ebd251"
  head "https://github.com/inspircd/inspircd.git", :branch => "insp20"

  bottle do
    sha256 "1b6846b77319ceb1f32433c1e4e442f055d8eb9daa695587186e22788753490b" => :high_sierra
    sha256 "4965f5c4e45b8106a23bd11156cb6e1fff7164800e0805c8704921722d50586d" => :sierra
    sha256 "48faab0b2b980c4184f9456ec7c48ab6d5d8174508e7fa114c7b0abfe93b457c" => :el_capitan
    sha256 "8786c5b0a4452c438c13a2a7a9dc74d7d01dde665ced7ac5088d10ab909c7edd" => :yosemite
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
