class LibpqxxAT6 < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.4.7.tar.gz"
  sha256 "3fe9f38df1f0f9b72c8fe1b4bc0185cf14b4ed801a9c783189b735404361ce7f"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "31d80459d21a2c53f3a56d2b17d7ea2715aef4a32b42156fe2f83d62bacac48d"
    sha256 cellar: :any,                 arm64_big_sur:  "b6f56911155c390dfbe7351fda8334b1dd47d7fed3d7001e767228144e45cc67"
    sha256 cellar: :any,                 monterey:       "257da71271b6e500f91a35623b951dd1ec37fd66d9b9a9c00ef9d1baa5c33396"
    sha256 cellar: :any,                 big_sur:        "e21e51c071cc9cb879d7ab688f3fba8cf8e32cf14f34779b04db95ec67d1289b"
    sha256 cellar: :any,                 catalina:       "29def17a973940490a25c20f5722f6ea4d0551e41cd7986b9025abef40b1534e"
    sha256 cellar: :any,                 mojave:         "4b544c65887866135d96226e2bf7c2b586664f8e1a049f6d3dbeca7195884a6f"
    sha256 cellar: :any,                 high_sierra:    "39aa6c090c8341c0e9be80d055345c8322ee6a9a908a0f7863479784cbd609f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "048e4249607f887c9787a40ca3b4b2092e5ffa8adc649f52940af42406fe5080"
  end

  keg_only :versioned_formula

  deprecate! date: "2020-06-23", because: :versioned_formula

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
