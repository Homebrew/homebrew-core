class LibpqxxAT6 < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.4.7.tar.gz"
  sha256 "3fe9f38df1f0f9b72c8fe1b4bc0185cf14b4ed801a9c783189b735404361ce7f"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "a6c097c77ca535f5714cb0fc2096a4ac382f241f9878a8253b37cb8bd3eb5188" => :catalina
    sha256 "a983077fe9a2cb76ed3189781724353d08861c27a51ebdd697df25a065aefe95" => :mojave
    sha256 "22b2fe737dd2546276ce7bc1679bc3bab7fb0070ef96a60e649af488d5ee7aab" => :high_sierra
  end

  keg_only :versioned_formula

  deprecate!

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"
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
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"
  end
end
