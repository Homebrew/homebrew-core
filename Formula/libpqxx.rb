class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.7.3.tar.gz"
  sha256 "11e147bbe2d3024d68d29b38eab5d75899dbb6131e421a2dbf9f88bac9bf4b0d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "735b7df4d11a673461099d606727b595d491ff1f73f441bd5cfdceced9706100"
    sha256 cellar: :any,                 arm64_big_sur:  "42e1a8488b64bdd59fe427c9dba9667b0f23bf4fad08d937fab81482064a8af9"
    sha256 cellar: :any,                 monterey:       "860504675d2b564be0b14e3240d22d65483d39bd1213ec3e2d4ebea7cc55dd16"
    sha256 cellar: :any,                 big_sur:        "efefcdbac601d3c83b3cd646e7a0fe2fd33ea4b91b7f101b8c07fbc6e0a16916"
    sha256 cellar: :any,                 catalina:       "92bf4e430fd554b0a415f6143ce589ac5e20650853fbde4baf7dd21e70bbe8a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d675a02a11124975690ccb5673bb8d0860c8d83c94518ea98bf52d61863a1e39"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
