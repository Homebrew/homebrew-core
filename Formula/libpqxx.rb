class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.1.0.tar.gz"
  sha256 "a36899821e4bc354f424c041d43a7f5c0def24d2b7bb3f486d0e6b131520603f"

  bottle do
    cellar :any
    sha256 "e693aa7fabaf82376e4d0f5b777ae941adb4cda510d9f8d8a6e7a207addfede3" => :high_sierra
    sha256 "086d51d3c496361a5bafd908d22ba45812eb557286c24dd13de1799396152058" => :sierra
    sha256 "9fa457b09dc52b654ac29937c83c81986d11e98efe37133b2ecdb7a12d158b11" => :el_capitan
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
