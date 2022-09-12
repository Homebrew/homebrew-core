class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.7.4.tar.gz"
  sha256 "65b0a06fffd565a19edacedada1dcfa0c1ecd782cead0ee067b19e2464875c36"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "41bb514c52d981ac96179d259a75cb67c0279030c8291db2ac7ec9fe1b55e706"
    sha256 cellar: :any,                 arm64_big_sur:  "2bc989c08cab03b73e5f71092e8a1dcc8bcd8d206b3fc50ed54399b642a31607"
    sha256 cellar: :any,                 monterey:       "0a21cb1e4cf425ba12d2a75ef844f7840a18d402537bca95610dbb800d56a808"
    sha256 cellar: :any,                 big_sur:        "de2ba50a393064fb97f664b939933d2ae74e3ce825375578896f812d7bb944e0"
    sha256 cellar: :any,                 catalina:       "61b12a60dacb5258d72f0219bf49023de032531ae56f25996ff88f3361cd2b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1091f0b1369f8ac44f91a245c86830027667b576c35dded87394229cbe30c96e"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  fails_with gcc: "5" # for C++17

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
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
