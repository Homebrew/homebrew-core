class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.7.3.tar.gz"
  sha256 "11e147bbe2d3024d68d29b38eab5d75899dbb6131e421a2dbf9f88bac9bf4b0d"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "bb4e6211a5dac2a3b2fc5d8c4aa59935fe8b0faf10331019609498cf1f37111d"
    sha256 cellar: :any,                 arm64_big_sur:  "212613f58fea12834c6b2509611b088a0f107dd7c8034101f0ad0bdb249efd3d"
    sha256 cellar: :any,                 monterey:       "624cf91610d110aa868effbf3d2d6edd9801fc4f781a182e407c14248174e515"
    sha256 cellar: :any,                 big_sur:        "a0c563d98010ceb86e95150df2b35a58bb4d514c20bd617f1c2b49b678c8407b"
    sha256 cellar: :any,                 catalina:       "9141884c598544669b068dcc42c9af896a84d065efd87b83f3661bd2409d6141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b26053f14cb3f20725c7f9491fb033ec03132136a1d8597e67f20676a69f2973"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

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
