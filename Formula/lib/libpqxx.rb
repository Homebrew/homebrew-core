class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/7.8.1.tar.gz"
  sha256 "0f4c0762de45a415c9fd7357ce508666fa88b9a4a463f5fb76c235bc80dd6a84"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "453f3839da9db0e2509848c86aa10c5cc4915870fbe50a78757a3430699d0ab0"
    sha256 cellar: :any,                 arm64_ventura:  "ea53f3f58887f5bcc70e963162cc63f26315ffea7b6d03c52861c2b6fa0cbb67"
    sha256 cellar: :any,                 arm64_monterey: "c89a565af9ef10c7fe236a240175d069dfd0f76f6a7002af83b3054be7b2d764"
    sha256 cellar: :any,                 arm64_big_sur:  "d74bd03e1a3379fa02d77d697e0abc900c3d5cf38fab56248bbef8e2c9b67974"
    sha256 cellar: :any,                 sonoma:         "fc18ca3448f01c46fb9050203e4d5475932ac85edb87143c6daf1fe328d0e7ed"
    sha256 cellar: :any,                 ventura:        "9ee8482ef40df031f9eecd0cef325434e6f2a043b1fb74f8c3f8e97ed21bfef4"
    sha256 cellar: :any,                 monterey:       "18210ca8b997649ccdb1c934708b5d8bbf79e1cc25c66e9c0a6214f9be5b536b"
    sha256 cellar: :any,                 big_sur:        "925b8914a35bdcf4425595ffb5c72bd3755b77c87813bf050c27c36448edc56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69e1d56dfe372bd8e57772c5564889ee599514d4cc8291407fa74f7382a6ab0e"
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  uses_from_macos "python" => :build, since: :catalina

  fails_with gcc: "5" # for C++17

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--disable-silent-rules", "--enable-shared", *std_configure_args
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
