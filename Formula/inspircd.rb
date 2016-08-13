class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "http://www.inspircd.org"
  url "https://github.com/inspircd/inspircd/archive/v2.0.22.tar.gz"
  sha256 "1e67d4e854ae2b7dc57efafb424609a51ebf11ed97d031e808dae7548ab9c03a"
  head "https://github.com/inspircd/inspircd.git", :branch => "insp20"

  bottle do
    sha256 "9654c3351e85793a83c289257387a4fe3f4af76e8f3790115f78c6b0fac62e34" => :el_capitan
    sha256 "f38925b809baa6282f92da6081f84a0e6e4816cb2c621440c2bc3dd279021c4d" => :yosemite
    sha256 "da7534958d9064b93cb4aef28375aacd08d3d72ba0119241678f92e84af3ce6b" => :mavericks
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
