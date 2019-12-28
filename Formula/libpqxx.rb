class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.4.5.tar.gz"
  sha256 "86921fdb0fe54495a79d5af2c96f2c771098c31e9b352d0834230fd2799ad362"
  revision 5

  bottle do
    cellar :any
    sha256 "02873d7d669665be207e947889c00e0faf872039fe9050cf4b9c31af5b04135b" => :catalina
    sha256 "c0466edc81a9d95e971b56716b51657e3177b52997e38bd6061ef508a8c6614b" => :mojave
    sha256 "2320ffbda4afd621b159cee98ae4595375ce8b052d5fbdf8fa06ab525bae59a2" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  def install
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"
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
  end
end
