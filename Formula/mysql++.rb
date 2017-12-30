class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.com/mysqlpp/home"
  url "https://tangentsoft.com/mysqlpp/releases/mysql++-3.2.3.tar.gz"
  sha256 "c804c38fe229caab62a48a6d0a5cb279460da319562f41a16ad2f0a0f55b6941"
  revision 1

  bottle do
    cellar :any
    sha256 "e896760f31b977fce886b2f9eb67ee70fa93491752ac48744458bfa74b5c1f35" => :high_sierra
    sha256 "44549b6b92ecf8288923b6111a67c3dcf16f5ba0a0ca47f4fd38a31b99545452" => :sierra
    sha256 "1f0e3bc7e6e25924bb95113ee0cbd7c99402dc51744682258b3548c756431239" => :el_capitan
    sha256 "f9837534007c15fdf73e607ddc58c1d5c0d1d20ff2de7e2d1dea20716b823cc9" => :yosemite
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
