class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.5.2.tar.gz"
  sha256 "62e140667fb1bc9b61fa01cbf46f8ff73236eba6f3f7fbcf98108ce6bbc18dcd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5d7d1131c04dc41a6277ab06f953e180fef6979be60d854e4fa02df7111e59f8"
    sha256 cellar: :any, big_sur:       "941aa261f18765bfed6888c94baaf7a0ad495ef8272229537a881e1ac8be5504"
    sha256 cellar: :any, catalina:      "f0304c955169cdec57747a49acb59556001944ddd83d6d53601aaa9806f25d4f"
    sha256 cellar: :any, mojave:        "e0fa3edf4874999fbf4062c9083c74d1517e974f1bb882b7f842a0d731cd5870"
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
