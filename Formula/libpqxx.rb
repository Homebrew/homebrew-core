class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.3.1.tar.gz"
  sha256 "c794e7e5c4f1ef078463ecafe747a6508a0272d83b32a8cdcfb84bb37218a78b"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "d1677be98c31ac3533053137ca68a9a99be1221e797305a26617cc9d797e5b9d" => :big_sur
    sha256 "56f976bd0211daafbb869d2f53aa368999812dec72eecfee43178cd71c95c295" => :arm64_big_sur
    sha256 "53ed6045a272a0369d445a23508cbda5f01ef4018ef72d63740e5b0d05885bcb" => :catalina
    sha256 "c9a15d608af5d566d0a790d9460f12b9a0589b193302f99a29e568aaca7a007e" => :mojave
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
