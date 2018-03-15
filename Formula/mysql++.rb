class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.com/mysqlpp/home"
  url "https://tangentsoft.com/mysqlpp/releases/mysql++-3.2.3.tar.gz"
  sha256 "c804c38fe229caab62a48a6d0a5cb279460da319562f41a16ad2f0a0f55b6941"
  revision 1

  bottle do
    cellar :any
    sha256 "62551ee383b5c68a1b74f3652e44fafc3ab210b63af765cb2a6318f09695c0b1" => :high_sierra
    sha256 "00b0c1e860ed384bb27fbbe53c62ea4cbbec592357a2744e8203ccf000c84c31" => :sierra
    sha256 "1668ebf91ee98d2d898f2b2eb75adba49f7bb3c8e353f2ac95f722da2858110b" => :el_capitan
  end

  depends_on "mysql"

  def install
    mysql_include_dir = Utils.popen_read("mysql_config --variable=pkgincludedir")
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-field-limit=40",
                          "--with-mysql-lib=#{HOMEBREW_PREFIX}/lib",
                          "--with-mysql-include=#{mysql_include_dir}"
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
    system ENV.cxx, "test.cpp", Utils.popen_read("mysql_config --include").chomp,
                    "-L#{lib}", "-lmysqlpp", "-o", "test"
    system "./test", "-u", "foo", "-p", "bar"
  end
end
