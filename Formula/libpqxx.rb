class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.1.0.tar.gz"
  sha256 "a36899821e4bc354f424c041d43a7f5c0def24d2b7bb3f486d0e6b131520603f"
  revision 1

  bottle do
    cellar :any
    sha256 "f03f468c080032b818c131c7a568a380d9507790d56808763f9e8a1625ee10f3" => :high_sierra
    sha256 "dde9619860ff5803fb2ef60f715c7aa1cfef88ae534ebb49944f8fd4b286beba" => :sierra
    sha256 "1ed4a94cf418f5f5b2f66b8ed3e06ba92755126bba76510890df097f2dfc7396" => :el_capitan
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
