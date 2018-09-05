class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.2.4.tar.gz"
  sha256 "91a295d9e06fc36db5d993970aa1928e053a57ec03bf6284a1c534844ed35ed3"
  revision 2

  bottle do
    cellar :any
    sha256 "70c47a06792e042ec1039b98fd7cf3bc5dd6398f84bd6bf8e89bbc25e8c29706" => :mojave
    sha256 "8017994020ce366492b79055e349730ffb2964e5fac11b3e734360e22b9e7986" => :high_sierra
    sha256 "599b8ac667629d5704a1822f64d0609bd0c4833c6b61b6164088beda8a7ceaa7" => :sierra
    sha256 "24c11214d49a0f493871beadbf8cbaac859b4b4393f74f8f0a880e0f269154a7" => :el_capitan
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
