class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.4.5.tar.gz"
  sha256 "86921fdb0fe54495a79d5af2c96f2c771098c31e9b352d0834230fd2799ad362"
  revision 2

  bottle do
    cellar :any
    sha256 "89235918ff61107cc58a5bc9fea32a93867be86d181371a41dd9bc16e5d5a7ed" => :mojave
    sha256 "9327a3f310272de1a1adcc0cd7f21ecb4f176f1097159720c5b7a169e70ed596" => :high_sierra
    sha256 "6b6bc25d3ec04e66d9a1bc097eb8db88541372636553407bfa10bb4b6e764d5b" => :sierra
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
