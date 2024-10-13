class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/7.9.2.tar.gz"
  sha256 "e37d5774c39f6c802e32d7f418e88b8e530404fb54758516e884fc0ebdee6da4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d88089c7284c6e48d32ac9a8913a4592d2402ba8724cee41d3d8e99aeedf508a"
    sha256 cellar: :any,                 arm64_sonoma:   "4bbe6bc59845beb22347415487ece9596a1547125b25cb79f863a73bd00a4b91"
    sha256 cellar: :any,                 arm64_ventura:  "1430202c780b48c6105e855ea8d419d8007c64efdb31ab47e470b400d10bc09a"
    sha256 cellar: :any,                 arm64_monterey: "578bccfc4ad118c1cdb92c1dbe202656db8a284ce3c6ac1cd04112b7b1276902"
    sha256 cellar: :any,                 sonoma:         "58ac23cc1afda6a9bcaa73888c4f336025cfebfcc95f96a60e041dfb36f4165b"
    sha256 cellar: :any,                 ventura:        "67b91dc955bef467e00fbe835fc34c4c7026b2c3e113fe7dde43d805fa6e0664"
    sha256 cellar: :any,                 monterey:       "0fb08adfdcd300f7cc93ee0b5a3fc8ede01ba43afc896091500b29c0adf168a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8434faf947afc1526b6da021efaa8e7d5b4cd5ab680f5eef2f191e797f09b3d7"
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
