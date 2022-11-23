class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.com/mysqlpp/home"
  url "https://tangentsoft.com/mysqlpp/releases/mysql++-3.3.0.tar.gz"
  sha256 "449cbc46556cc2cc9f9d6736904169a8df6415f6960528ee658998f96ca0e7cf"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?mysql\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "683d70555153779df51d77592cfb9e216caebff08ce0f46914f6c0a92e376eed"
    sha256 cellar: :any,                 arm64_monterey: "d2e0c2dc9d6e377683bceba98294b05cf37b7e27f09fa16bc5e1a008d5e56546"
    sha256 cellar: :any,                 arm64_big_sur:  "986394ee4f18b46c60d1322cedb944cf55f3bc6c260cb48f5cb403e706370cdc"
    sha256 cellar: :any,                 ventura:        "0879c16b25edce02246f09bffc4dcd94fb21fafc9e4a445accf9c1827548a880"
    sha256 cellar: :any,                 monterey:       "75aba44deb5c3759891533ca3b1d9c1a4a04bca27a9ad218f4ffa7c5fdced92b"
    sha256 cellar: :any,                 big_sur:        "73d8bcba51380239e981d14636a1ac225ac3e4c7b42b67610441ce080f956429"
    sha256 cellar: :any,                 catalina:       "37f643c40b54098cdcc42a0dd19747e153f9e11ef8fb02d697e6b8ef360f998e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ad62612f64296dd4faa68b07a3a008865f948685871bcea234be57d05f34d6d"
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
