class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.3.0.tar.gz"
  sha256 "55563821727310828cd79737732ca7e14a49dbbaa86bdce7c5829d440dafde59"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "b2299910a772caf6479360f95f59876681c66d5a40349f7ce012250dd987ff2d" => :big_sur
    sha256 "85db8ec663721f48161cd6fd33fdeb87476c9086f1db3618c2b3d1a146c5a295" => :catalina
    sha256 "6c1337228d446aba1f625567a141a985e4191e3eb5053238b78d4183a3233752" => :mojave
    sha256 "b4cd9d66cb35a7d69b4377c5c6f5c2b72ce7da44e4c9f6eea25fe731c3cf1e4a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
