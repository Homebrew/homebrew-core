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
    sha256 cellar: :any,                 arm64_big_sur: "e2cc8829c4bab8218a31e738487ac902a6452e44b107790af1ae538c4e6986bc"
    sha256 cellar: :any,                 big_sur:       "3af8c69e77ca13685b96f10784c09ceed81ada15c6f53d0c2758b10fc0a7d6b1"
    sha256 cellar: :any,                 catalina:      "f38e5b1a57994f3be9479fd58e03fea72f0ddfe8c142df987cfdeddeb2714c56"
    sha256 cellar: :any,                 mojave:        "ba00ec69ab593917365180b6161676e71b4f96c3f655dd26ae65dccd02ac0aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e72e034fad87e1bebdd19df274bac75c0ae9e6f93e5bf0abb076f9b055e46a7"
  end

  depends_on "mysql-client"

  on_linux do
    depends_on "gcc"
  end

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
