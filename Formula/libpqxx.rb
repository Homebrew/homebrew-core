class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.0.0.tar.gz"
  sha256 "81cac92458efd799fadb0374107464320d93eba71de05aedf21afb9c8dda7c3a"

  bottle do
    cellar :any
    sha256 "4a146fd2c38fed728cfbc51502c9976953cf15e0a278e5d0b0063006b6feedf9" => :high_sierra
    sha256 "e09f197b4b6d84212cbe09a5c71b6ebab248a1e634c81377d6b8d7172cb251ed" => :sierra
    sha256 "14cabe29c05d71602958b86c775681a9dc530ba269378a5a2c41737b8aa80b1f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :postgresql

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
