class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.2.5.tar.gz"
  sha256 "36fcf8439ac7f7cc68b21e95b20e921ece4487cda1cc1d09b798a84e7cb3a4b7"
  revision 2

  bottle do
    cellar :any
    sha256 "7ef43f169467dc9988a46e99e396ffd643c1e77fb688192684035132323741fb" => :mojave
    sha256 "c8a35a13240803d29e0706a4cc752c06f52823f891ce44147e8ef91bbb87ff76" => :high_sierra
    sha256 "3e0a2889cf13015c5d3996a270c3e13fbfb440ca77ad374cb9c85c7be33814c8" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "postgresql"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"

    # `pg_config` uses Cellar paths not opt paths
    postgresql_include = Formula["postgresql"].opt_include.realpath.to_s
    assert_match postgresql_include, (lib/"pkgconfig/libpqxx.pc").read,
                 "Please revision bump libpqxx."
  end
end
