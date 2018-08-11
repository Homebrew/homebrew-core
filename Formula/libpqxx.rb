class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.2.4.tar.gz"
  sha256 "91a295d9e06fc36db5d993970aa1928e053a57ec03bf6284a1c534844ed35ed3"
  revision 2

  bottle do
    cellar :any
    sha256 "6e640d14732d03ca8f2f8e6f665f0e9cf69b95c4d624f3e70a0c9ce563158bbe" => :high_sierra
    sha256 "4042a2d3979edf22466e8ad113dc56e77185d477e396aa9ba1c82b4d97bc7f14" => :sierra
    sha256 "14d64a8dbe0a66955ccf091d582ad115549392e472f38d5903cb169c79699fd2" => :el_capitan
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
