class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.3.1.tar.gz"
  sha256 "c794e7e5c4f1ef078463ecafe747a6508a0272d83b32a8cdcfb84bb37218a78b"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "31966e7684f2d14bbce813826ac6a8fd32fa7a5994eb42e288a06dd9644f64a1" => :big_sur
    sha256 "8a331a7d9b847c409e959afdf7ca19eea8ed294b6a511fc6f11a8a2af09adb28" => :arm64_big_sur
    sha256 "e326cc5eaced4f2499f8cfc53d807070a57a6ff6e166ae3712794c96688bed74" => :catalina
    sha256 "c9cb4e5f9ee9d134d55a2fe6d8384b29765c9a301356aef096fa967136bac6bf" => :mojave
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
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
