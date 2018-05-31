class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.2.4.tar.gz"
  sha256 "91a295d9e06fc36db5d993970aa1928e053a57ec03bf6284a1c534844ed35ed3"

  bottle do
    cellar :any
    sha256 "9f20a9f6a392fb7fc9916c92bb2042784e8e1faecba094fe7eaedd3d7f0774dd" => :high_sierra
    sha256 "1d28dbef78951eae6bc6fc8eafacb373b43d4965cdea101c40cc95376f199eb6" => :sierra
    sha256 "7f09cb397691bccfd24bbe3d31ae85ba3794f3c32381b1d1142509c7eb9812fe" => :el_capitan
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
