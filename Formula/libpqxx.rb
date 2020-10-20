class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.2.0.tar.gz"
  sha256 "c482a31c5d08402bc9e8df8291bed3555640ea80b3cb354fca958b1b469870dd"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "c2c99b7a5706d977c933b02029c2f6960b3e82ca87f0a26393859f5e399879d9" => :catalina
    sha256 "ee66e2a782c70d9c6e00058527e2931950b3e76966033c4f19a95e144e2d22e4" => :mojave
    sha256 "dd4090bffc158c07fc82e3b0f235ee3856464e521fe3a0d2683b45cd336b206e" => :high_sierra
  end

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
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no runnning postgresql server
    # system "./test"
  end
end
