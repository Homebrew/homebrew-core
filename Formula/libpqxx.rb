class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.1.2.tar.gz"
  sha256 "3af7b4cfd572c67275ad24fea31bcf9d9f365ec16a1b7e90d4bde930936707f3"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "4600e04403f227ce18b789e236dc78faf8fd9ba230c99ba71e1e011bf33d21d8" => :catalina
    sha256 "7f99040c5cb0cb12dec832043fc3789b30e323ee3759cea291b8783caa48e43a" => :mojave
    sha256 "4016b954fb4052fd8988cfbd569c32ae8700f1c5b3da60eaf576672545f18df2" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"
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
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"
  end
end
