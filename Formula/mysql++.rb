class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.com/mysqlpp/home"
  url "https://tangentsoft.com/mysqlpp/releases/mysql++-3.3.0.tar.gz"
  sha256 "449cbc46556cc2cc9f9d6736904169a8df6415f6960528ee658998f96ca0e7cf"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?mysql\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "84187bd98edc4c965935f5cbd38572bbc01c755bd8fa31808571c66ccd6fe589"
    sha256 cellar: :any, big_sur:       "8217141b2c7f02ee63c256b20bac582b8dcfca969b3bc1658cbe3a234e5eff98"
    sha256 cellar: :any, catalina:      "b7e5c1ede992e84fc7200d5216b2643cd8a3e5839a3b8610640c67d6ad675a12"
    sha256 cellar: :any, mojave:        "6eebecae2b6b3f1b4144c0e731ab8774eb9ed4f918369b6593c55d88258dd07e"
  end

  depends_on "mysql-client"

  def install
    mysql = Formula["mysql-client"]
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-field-limit=40",
                          "--with-mysql-lib=#{mysql.opt_lib}",
                          "--with-mysql-include=#{mysql.opt_include}/mysql"

    # Delete "version" file incorrectly included as C++20 <version> header
    # Remove when fixed upstream
    rm "version"

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
