class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/5.0.1.tar.gz"
  sha256 "21ba7167aeeb76142c0e865127514b4834cefde45eaab2d5eb79099188e21a06"
  revision 1

  bottle do
    cellar :any
    sha256 "e0c52df32c3b69aefefe4782fde933e16abb67e6491e2e498bd244dc647268a5" => :high_sierra
    sha256 "e5c78c98aa7f8e087e8bb07a8e36133acda2dbb2f0c8ccfd9c0e16b99921e72a" => :sierra
    sha256 "312d77e1693f03c7ae67e4b699a9e129ec33bae1426f9df940c4c76ff5c20c2a" => :el_capitan
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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lpqxx", "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"

    # `pg_config` uses Cellar paths not opt paths
    postgresql_include = Formula["postgresql"].opt_include.realpath.to_s
    assert_match postgresql_include, (lib/"pkgconfig/libpqxx.pc").read,
                 "Please revision bump libpqxx."
  end
end
