class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.5.4.tar.bz2"
  sha256 "a6cf327189ca0df2fb9d5633d7326c460fe2b61684745fd7963e79a6dd0dc82e"
  revision 2

  bottle do
    sha256 "554fcbcfe8247cbb3fea43679eaaf085b9dc8d5d39476db7c5e4b1fa6957316c" => :el_capitan
    sha256 "21dcb678c086d3f79d2971d7546c8cd501128d1d0954eb83e8fc608146cd779f" => :yosemite
    sha256 "fb8a18dac802ff2e407ee486f900007e21720da0e0434145ac419afbd6da7c4d" => :mavericks
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr."

  option :universal

  depends_on "apr"
  depends_on "openssl"
  depends_on "postgresql" => :optional
  depends_on "mysql" => :optional
  depends_on "freetds" => :optional
  depends_on "unixodbc" => :optional
  depends_on "sqlite" => :optional
  depends_on "homebrew/dupes/openldap" => :optional

  def install
    ENV.universal_binary if build.universal?

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    args = %W[
      --prefix=#{libexec}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-pgsql=#{Formula["postgresql"].opt_prefix}" if build.with? "postgresql"
    args << "--with-mysql=#{Formula["mysql"].opt_prefix}" if build.with? "mysql"
    args << "--with-freetds=#{Formula["freetds"].opt_prefix}" if build.with? "freetds"
    args << "--with-odbc=#{Formula["unixodbc"].opt_prefix}" if build.with? "unixodbc"

    if build.with? "openldap"
      args << "--with-ldap"
      args << "--with-ldap-lib=#{Formula["openldap"].opt_lib}"
      args << "--with-ldap-include=#{Formula["openldap"].opt_include}"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/apu-1-config", "--link-libtool", "--libs"
  end
end
