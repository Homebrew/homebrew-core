class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.com/mysqlpp/home"
  url "https://tangentsoft.com/mysqlpp/releases/mysql++-3.2.5.tar.gz"
  sha256 "b780beeb3a9cd9ce6a9043028527484df8e822c58c5274d4d67ec5ba2fc0a778"
  revision 1

  bottle do
    cellar :any
    sha256 "657ebf2f50f14f877b6892bbee2c5e92aef47093a22918a9d14b871769d76a30" => :catalina
    sha256 "0e2b71648130ccac76a5d861e609538ffc697e629db9c352b0f69b513df4aa4e" => :mojave
    sha256 "a8bb0d5cdc09c45b28b15e6e3de0b20260b8f11f395fb968d1f6a4c931d9a292" => :high_sierra
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
