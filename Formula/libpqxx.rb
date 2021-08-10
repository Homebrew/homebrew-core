class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.6.0.tar.gz"
  sha256 "8194ce4eff3fee5325963ccc28d3542cfaa54ba1400833d0df6948de3573c118"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ebdfe3e913d5afbde0f306f0ba1068bc1935b8f5b33a07868b5a2507fd1feda1"
    sha256 cellar: :any,                 big_sur:       "bb2989b2d1a03abb75e4e49ef80b12c5ab735e9eb4fd1d3b3c617c8ac4790bbb"
    sha256 cellar: :any,                 catalina:      "5d929d781d272625dddbdecd737b7afd17425042a54ca77e49c8a1b7902ef123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03c98f0676015f7bd07eb61cf41f5cec431e95529edfca116ae91f86ab4b274a"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

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
