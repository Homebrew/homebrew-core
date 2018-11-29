class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.2.5.tar.gz"
  sha256 "36fcf8439ac7f7cc68b21e95b20e921ece4487cda1cc1d09b798a84e7cb3a4b7"
  revision 1

  bottle do
    cellar :any
    sha256 "04850a431cfaf76131405c94db2bbbbb2e8af976c42170fde4a1c6535c54e896" => :mojave
    sha256 "51822e01d252f9ac6839adeddd41952778ca4a0dcb65d1a7c6706d2f6075cc43" => :high_sierra
    sha256 "eb07738d6ea3f8359eb9ef56694d84c50fff9a17d255c544e0db8a870578fb94" => :sierra
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
