class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.0.0.tar.gz"
  sha256 "81cac92458efd799fadb0374107464320d93eba71de05aedf21afb9c8dda7c3a"
  revision 2

  bottle do
    cellar :any
    sha256 "dba9214a5c6d8dbdd0aebddc58420b25c1599910aa622dc4de6cf6d5cb791bbc" => :high_sierra
    sha256 "b899b135aa6462d9fc6c99a0dee054b920d4be2d0d69131accbf27675c795e63" => :sierra
    sha256 "e410bb5cb85722629e55f45a4b13dfb57ef74bb9a6c254c3bc41e408b0a77729" => :el_capitan
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
