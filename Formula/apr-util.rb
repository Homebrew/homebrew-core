class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.6.0.tar.bz2"
  sha256 "8474c93fa74b56ac6ca87449abe3e155723d5f534727f3f33283f6631a48ca4c"
  revision 1

  bottle do
    sha256 "b1c1fbfaf17d23b788ac43b8c37694e48b1417326918af000e19c6b329d78410" => :high_sierra
    sha256 "3b72b3d5133fbc44a9b731c7839502b8dead4cc7d269f3bcd555bb8df15fcf5e" => :sierra
    sha256 "4b5777d34c8bbbc00a193c3b292d175ead8bdc0a3de0ea520f6630877dc6f60c" => :el_capitan
    sha256 "f18a9ee269a86582d0c51f3ff825031abc65854bcaf15a1b5713a02df2aad637" => :yosemite
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr"

  depends_on "apr"
  depends_on "openssl"
  depends_on "postgresql" => :optional
  depends_on "mysql" => :optional
  depends_on "freetds" => :optional
  depends_on "unixodbc" => :optional
  depends_on "sqlite" => :optional
  depends_on "openldap" => :optional

  def install
    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    args = %W[
      --prefix=#{libexec}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-crypto
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

    rm Dir[libexec/"lib/*.la"]
    rm Dir[libexec/"lib/apr-util-1/*.la"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apu-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apu-1-config --prefix")
  end
end
