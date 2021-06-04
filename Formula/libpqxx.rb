class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.5.2.tar.gz"
  sha256 "62e140667fb1bc9b61fa01cbf46f8ff73236eba6f3f7fbcf98108ce6bbc18dcd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8233c21f3363d037f6f79cf7754ac6bf515a307a1c090a3182e5a064859d526c"
    sha256 cellar: :any, big_sur:       "df129caeb02ff03f2b146f6558471f105ff3ba67868e186d011f98444d40ee8a"
    sha256 cellar: :any, catalina:      "b442129051871681bbb6205dcee1730baf1a8ed2f07ff6119700b3376c23c069"
    sha256 cellar: :any, mojave:        "caa8680e0f0ef430fc9c31e4212054f2d6aca355bf68164637deac6d307c1c3b"
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
