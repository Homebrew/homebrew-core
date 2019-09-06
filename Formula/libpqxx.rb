class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.4.5.tar.gz"
  sha256 "86921fdb0fe54495a79d5af2c96f2c771098c31e9b352d0834230fd2799ad362"
  revision 3

  bottle do
    cellar :any
    sha256 "1db58d276d390dcff3308ec986ab97d0255f8ac90408430f35ec5f60adba0bf9" => :mojave
    sha256 "33ddf4baad228b955914bf4c6c9fabe22458d5aaa345094ba682974576350994" => :high_sierra
    sha256 "fc29d0e35a593d461f4ba570b66431a241743210e467bcba47dcbc46956083f4" => :sierra
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
