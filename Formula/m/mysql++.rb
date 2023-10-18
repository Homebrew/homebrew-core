class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.com/mysqlpp/home"
  url "https://tangentsoft.com/mysqlpp/releases/mysql++-3.3.0.tar.gz"
  sha256 "449cbc46556cc2cc9f9d6736904169a8df6415f6960528ee658998f96ca0e7cf"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?mysql\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eee1456f0bc1e77efe95cad1415ca377525ae10c618cbb033c190dc1309bafca"
    sha256 cellar: :any,                 arm64_ventura:  "9244f1ab36df8527bde5bbfa1896fc43511076cb4c1312b70b88dda97cf514d4"
    sha256 cellar: :any,                 arm64_monterey: "c042304bf3959e8ff9f5f98c6e7121af78daeeec0d3ae9efb650eabaa713536a"
    sha256 cellar: :any,                 arm64_big_sur:  "2a0f6e540ab0ebb1594fae343e8358d98cf22bda4887d039f9e05155ec9f5dab"
    sha256 cellar: :any,                 sonoma:         "a0f19621b399f1e21fa6cc9d902012280d960c0f39c37fbfcbd1b63c8c483180"
    sha256 cellar: :any,                 ventura:        "665e4cc095a04a2e7d04edc1f8fb7f306a1b4923b2be8afce48b39c107873c43"
    sha256 cellar: :any,                 monterey:       "675b77e64a1ca5dbb5fc8dff4a720a4182e7143906cceecbd074d274f5b19cb4"
    sha256 cellar: :any,                 big_sur:        "aeaf076e16d85aaee1e5dddd2c926bd0a8cc142735ab585a7a1530e41dd15b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d04204c93a9db0aa946a735e4bef186a0f1caddab7c985c5244b8d39e129d9ec"
  end

  depends_on "mysql-client"

  fails_with gcc: "5"

  def install
    mysql = Formula["mysql-client"]
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-field-limit=40",
                          "--with-mysql-lib=#{mysql.opt_lib}",
                          "--with-mysql-include=#{mysql.opt_include}/mysql"

    # Delete "version" file incorrectly included as C++20 <version> header
    # Issue ref: https://tangentsoft.com/mysqlpp/tktview/4ea874fe67e39eb13ed4b41df0c591d26ef0a26c
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
