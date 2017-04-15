class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "https://tangentsoft.net/mysql++/"
  url "https://tangentsoft.net/mysql++/releases/mysql++-3.2.3.tar.gz"
  sha256 "c804c38fe229caab62a48a6d0a5cb279460da319562f41a16ad2f0a0f55b6941"

  bottle do
    cellar :any
    rebuild 1
    sha256 "50fb897ad1253fb2355ea2d42500e90f352f78d6df218db51c381a7ce8122cbf" => :sierra
    sha256 "75fdc6bbf0aacac8b4014ea232588e2eb37c4f051573754ad45f0404cfdebc13" => :el_capitan
    sha256 "5806dd86bc995dcfd76503453102bf0507194cfae0064837aa899ab2d00825a0" => :yosemite
  end

  depends_on :mysql

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
    (testpath/"test.cpp").write <<-EOS.undent
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
