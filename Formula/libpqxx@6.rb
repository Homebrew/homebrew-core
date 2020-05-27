class LibpqxxAT6 < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.4.6.tar.gz"
  sha256 "2280621eee7ec675ed6751abac2273f0ac41395e99be96e06584a54a0cc3985a"

  bottle do
    cellar :any
    sha256 "9e895c25d4b2bcab931ae5095e7710ee71005faba3607fb4b94e87bbb0df1617" => :catalina
    sha256 "9bbc89817da8c93f4fcad89e9ed43545da579733db8d77dd313e1b0fc375adca" => :mojave
    sha256 "040431f687f56ae15c0a9109b2c74d1f4a7ab643ef64ee9f376a76d1c4837207" => :high_sierra
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
