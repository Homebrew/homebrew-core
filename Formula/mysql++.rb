class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.com/mysqlpp/home"
  url "https://tangentsoft.com/mysqlpp/releases/mysql++-3.2.5.tar.gz"
  sha256 "839cfbf71d50a04057970b8c31f4609901f5d3936eaa86dab3ede4905c4db7a8"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    cellar :any
    sha256 "8217141b2c7f02ee63c256b20bac582b8dcfca969b3bc1658cbe3a234e5eff98" => :big_sur
    sha256 "84187bd98edc4c965935f5cbd38572bbc01c755bd8fa31808571c66ccd6fe589" => :arm64_big_sur
    sha256 "b7e5c1ede992e84fc7200d5216b2643cd8a3e5839a3b8610640c67d6ad675a12" => :catalina
    sha256 "6eebecae2b6b3f1b4144c0e731ab8774eb9ed4f918369b6593c55d88258dd07e" => :mojave
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
