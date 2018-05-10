class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.1.1.tar.gz"
  sha256 "7b4f37dab4b17b71ef415ffa37f5102ef6bc12647e42f0abaaf6febeeefb8b1e"
  revision 1

  bottle do
    cellar :any
    sha256 "2fe9395ca3528b8f165be947cf1f2696d729b73dca8981d51ce321a0475bfedb" => :high_sierra
    sha256 "a9cbbd18c4c2adb8065d0f1671b0c6346b54326849bd47bebf2bff64ed8a6dd3" => :sierra
    sha256 "21854ed4d76c5e00144c403b24658b8a61a56b0e66e02659dda55038f287879d" => :el_capitan
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
