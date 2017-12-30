class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.0.0.tar.gz"
  sha256 "81cac92458efd799fadb0374107464320d93eba71de05aedf21afb9c8dda7c3a"
  revision 1

  bottle do
    cellar :any
    sha256 "a8bcc04c02c83715e428a21f6a04007c55856a42946a657c387d34c70cc7639b" => :high_sierra
    sha256 "ec66894b8f4959662204c53532f5963bc64e3c89a8471e2bee43bf42220251ef" => :sierra
    sha256 "867e5ba4984a3be9480c11b5e0adb1687670162a9d5571d4050d46c6f66e9381" => :el_capitan
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
