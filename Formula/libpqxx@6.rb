class LibpqxxAT6 < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/6.4.7.tar.gz"
  sha256 "3fe9f38df1f0f9b72c8fe1b4bc0185cf14b4ed801a9c783189b735404361ce7f"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "e974d053a47127847a9643a1cf6a6b433d60ec95d583b56a877e2cd115819793"
    sha256 cellar: :any,                 arm64_big_sur:  "1bc5d58c42e2b17d2dadf9e3ed6658f29b8cee2c1a6528c938e9f35dfb74f0de"
    sha256 cellar: :any,                 monterey:       "344daa30b2c46d3cfafb04e343c12855e245e8d7a56c6f64b9924083ff6a8a0a"
    sha256 cellar: :any,                 big_sur:        "fcf3b10ca0fc40cd85498d242c5daed948dd0b51bc1a435fb0f297f03ad87d10"
    sha256 cellar: :any,                 catalina:       "646a08fa806d2f86d0d352daa71a3bdb254f73fa950d84c64ad8703d44cef9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f90f07fc8b266b4acff9ff552305b0b352220e77315d777536a6565c291934"
  end

  keg_only :versioned_formula

  disable! date: "2022-07-31", because: :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
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
