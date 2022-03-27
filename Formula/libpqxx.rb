class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.7.2.tar.gz"
  sha256 "4b7a0b67cbd75d1c31e1e8a07c942ffbe9eec4e32c29b15d71cc225dc737e243"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9586e74720f37c23c23130bc5bdc355104df5f0ee9ab29e97e190fbc5b94b1b9"
    sha256 cellar: :any,                 arm64_big_sur:  "fc0a0e304f24767bb3d3dcbf21ff29639ffbe2a3da55e084abeded630126ab26"
    sha256 cellar: :any,                 monterey:       "6d87da98c10ed6ef49a6c348f031f14e5b7f87edd8d18d2a78b2e8dd0eaf3392"
    sha256 cellar: :any,                 big_sur:        "d62d562ecd151257207ceffe194b283d2103367ec75f04c79dced3c2244cc951"
    sha256 cellar: :any,                 catalina:       "d01e417823be1eb0c2350f4cd04c918f5924ef9004c9e537a3cf0f3dae3b19f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcc4c93a8d57bfd9b5b692c8a4e758f8650c037904c2c99753b38c284b599496"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
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
