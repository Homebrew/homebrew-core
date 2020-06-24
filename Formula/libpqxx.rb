class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.1.2.tar.gz"
  sha256 "3af7b4cfd572c67275ad24fea31bcf9d9f365ec16a1b7e90d4bde930936707f3"

  bottle do
    cellar :any
    sha256 "b345cab517eb13cdd870059c16d48c61a10b5bae38c086a808a705120282ecd3" => :catalina
    sha256 "bcdb2b1bbb468ff8f2cacc8e020e07f64da6a0669e981d5c397c2d2adc284b8a" => :mojave
    sha256 "62a1a92df805584ff9ffd9321996767d814fd2a84167b1cb0130bc7c6d0bb4a6" => :high_sierra
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
