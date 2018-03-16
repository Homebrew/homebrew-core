class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.1.1.tar.gz"
  sha256 "7b4f37dab4b17b71ef415ffa37f5102ef6bc12647e42f0abaaf6febeeefb8b1e"

  bottle do
    cellar :any
    sha256 "2e496888c6e5b1887217bcadc656f00c2f5c50e7c6bc368b9d5efd350d5d6185" => :high_sierra
    sha256 "8d02167d314d158da9ac1f14c2fe64fcf530f8518b125e2d5cda4500c262d726" => :sierra
    sha256 "94001fdb6e6e9acf41d916640284ddac9f19d9dbec8fa83aff1ae0e9b4060301" => :el_capitan
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
