class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.2.4.tar.gz"
  sha256 "91a295d9e06fc36db5d993970aa1928e053a57ec03bf6284a1c534844ed35ed3"

  bottle do
    cellar :any
    sha256 "a5426e7649a5cecac88f76ac23dac89c022ba825301556acbc81e8acf3bfc226" => :high_sierra
    sha256 "15d7fe34b0fc5b21dd451145de6b5668c95dfc748af00fe526477778cc6fab82" => :sierra
    sha256 "3d95610cf8e82f64adaf6e7feae4fabc0006b7ee3bf67b36c8c075fb052c8fe8" => :el_capitan
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
