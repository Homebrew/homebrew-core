class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.0.0.tar.gz"
  sha256 "81cac92458efd799fadb0374107464320d93eba71de05aedf21afb9c8dda7c3a"
  revision 1

  bottle do
    cellar :any
    sha256 "eb04c7f827ab60a18867fedd39bdc32d3aa05c73172de7fd03bb1ba326f8e89f" => :high_sierra
    sha256 "9253308b2fcb5771b5df8954ea473db90221e5a5baa696bcbef36e900f51268e" => :sierra
    sha256 "32a97703d5e724f4be7dde81fcb8ebb666486294b9879224df1976c053fb0480" => :el_capitan
  end

  depends_on "pkg-config" => :build
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
