class LibpqxxAT6 < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.4.7.tar.gz"
  sha256 "3fe9f38df1f0f9b72c8fe1b4bc0185cf14b4ed801a9c783189b735404361ce7f"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "e21e51c071cc9cb879d7ab688f3fba8cf8e32cf14f34779b04db95ec67d1289b" => :big_sur
    sha256 "b6f56911155c390dfbe7351fda8334b1dd47d7fed3d7001e767228144e45cc67" => :arm64_big_sur
    sha256 "29def17a973940490a25c20f5722f6ea4d0551e41cd7986b9025abef40b1534e" => :catalina
    sha256 "4b544c65887866135d96226e2bf7c2b586664f8e1a049f6d3dbeca7195884a6f" => :mojave
    sha256 "39aa6c090c8341c0e9be80d055345c8322ee6a9a908a0f7863479784cbd609f5" => :high_sierra
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
