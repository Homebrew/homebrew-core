class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.2.0.tar.gz"
  sha256 "c482a31c5d08402bc9e8df8291bed3555640ea80b3cb354fca958b1b469870dd"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "06603e0e6c8b28697c1dbce085ab9af400d017234f248ba05d43bc9189c63339" => :catalina
    sha256 "a272c30a9b459e5fb2b98448a37cb625db71f55334d69c56534c7083fb013eda" => :mojave
    sha256 "420ebd77efbe086f93efb2aac4794de96eeb9e6ef09dd0451f2e254ebcf0e4fd" => :high_sierra
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
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"
  end
end
