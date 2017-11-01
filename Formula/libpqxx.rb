class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/5.0.1.tar.gz"
  sha256 "21ba7167aeeb76142c0e865127514b4834cefde45eaab2d5eb79099188e21a06"

  bottle do
    cellar :any
    sha256 "81096e1c784882ea5f0c2db7252d333fb43f987f7f010616cb5a30fdaed5ef1f" => :high_sierra
    sha256 "660779449eac96fdab22b28e28a8d8672de8baffb3b5cc35415fcc5b6fda1ab7" => :sierra
    sha256 "ef820631f156b0912ab484c74f97e658b81c5dc2daa30d0eac74e8ff70a4174f" => :el_capitan
    sha256 "096d1506a94e0aff6bcb09e6f7b952d35b701ef053a5e113410989e80ff6508e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :postgresql

  def install
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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lpqxx", "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"
  end
end
