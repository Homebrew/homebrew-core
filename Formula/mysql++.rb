class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.com/mysqlpp/home"
  url "https://tangentsoft.com/mysqlpp/releases/mysql++-3.2.5.tar.gz"
  sha256 "b780beeb3a9cd9ce6a9043028527484df8e822c58c5274d4d67ec5ba2fc0a778"

  bottle do
    cellar :any
    sha256 "9fdde4d5d3add26f37cc3640cdf4b0687cda260c0467a51a9e9cf6c5d263e482" => :catalina
    sha256 "6e0bd5060ad63d2271d92b2ed4e8eacdabff05598c134f3506d436fa5a3f9b2a" => :mojave
    sha256 "1c0ca1caf7821bada3f3f3a31fb1dffc23695ea65dc4abf7641c4e42abea1431" => :high_sierra
    sha256 "e78c8f7ea89a07d3aa4ac5eaac2e48782c85b6ea2612fcfa5ba4a59f481933a4" => :sierra
  end

  depends_on "mysql-client"

  def install
    mysql = Formula["mysql-client"]
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-field-limit=40",
                          "--with-mysql-lib=#{mysql.opt_lib}",
                          "--with-mysql-include=#{mysql.opt_include}/mysql"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mysql++/cmdline.h>
      int main(int argc, char *argv[]) {
        mysqlpp::examples::CommandLine cmdline(argc, argv);
        if (!cmdline) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["mysql-client"].opt_include}/mysql",
                    "-L#{lib}", "-lmysqlpp", "-o", "test"
    system "./test", "-u", "foo", "-p", "bar"
  end
end
