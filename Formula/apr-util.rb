class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.6.0.tar.bz2"
  sha256 "8474c93fa74b56ac6ca87449abe3e155723d5f534727f3f33283f6631a48ca4c"

  bottle do
    sha256 "8bfcb9021f0f213ced509efb5afb7851eb28c33d624acf17bb5121e3a71ff36f" => :sierra
    sha256 "663eff863f4c7037cbd9c9f9667c784b6fc5df5f8c2b89d9f70f9eb40a3f59fe" => :el_capitan
    sha256 "8f9e70f286f8cee9a9b5630f99318def94ee09d4a314618c295e2f5ffe6b5b38" => :yosemite
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

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apu-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apu-1-config --prefix")
  end
end
