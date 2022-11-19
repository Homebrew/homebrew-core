class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.7.4.tar.gz"
  sha256 "65b0a06fffd565a19edacedada1dcfa0c1ecd782cead0ee067b19e2464875c36"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "4f7eac329b43c9339b132bf4dfb9fd8bdfd157b38372d62fff7fb07a46f81fed"
    sha256 cellar: :any,                 arm64_monterey: "efc6a46c8f5be1b0cdba4b225d2c5ee6ab4a1ab781c6d15e3e91377b75086b27"
    sha256 cellar: :any,                 arm64_big_sur:  "4d404ad40773faa6ee7c43f265dfad2469e6df3b225f081791beafca23e08ba6"
    sha256 cellar: :any,                 ventura:        "ab9d2a71d7e69db88b1ed5a7fb10cabe6e9a9c9cf6c41385196f3bc5957f5cce"
    sha256 cellar: :any,                 monterey:       "817cffc912456f0e233dbee4be5db19bad19374051c27179b44af3da228470d3"
    sha256 cellar: :any,                 big_sur:        "225c2c1f68f97c7cd1dc12e252dba50a7b987a8e6897f76a2091b5d81ea9f993"
    sha256 cellar: :any,                 catalina:       "970f82f123653e725658e03e5cf1d8de48ba0af2d7e9a2eee7c01249fbcaac6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d52e95a1ebd81fca0bd0539e969cfbdaeea9a2cc615e19aa527678ace77cc082"
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
