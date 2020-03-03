class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.0.4.tar.gz"
  sha256 "b56b441eb49755b39f0ba194b81047f7596540ee23c1caa8aa1b963f1bded9f5"

  bottle do
    cellar :any
    sha256 "9f7a06c5aec1200b4c27e754fa0f751cf5084065b4dd268f870d60eca30257c5" => :catalina
    sha256 "461042302eadaee751e2792402f25bf190386fd9f443a4b5f00be2acb8d47474" => :mojave
    sha256 "9f1202b31703fb3b716668de6e9b48543faf517e6e419cb68b61d92bad20cb47" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"
    ENV.append "CXXFLAGS", "-std=c++17"

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
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"
  end
end
