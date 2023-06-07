class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.7.5.tar.gz"
  sha256 "c7dc3e8fa2eee656f2b6a8179d72f15db10e97a80dc4f173f806e615ea990973"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1af84c6b2644a232082d8753c8d0e13f67222a378bff90a7c96081d62a8cd9a"
    sha256 cellar: :any,                 arm64_monterey: "12682ca4dd9bce5d732fc0e6c05685c8384db504b074d5ca8d3dec0a9a940dab"
    sha256 cellar: :any,                 arm64_big_sur:  "67a616dfc0035740be1dfaf7555c3a63e5c0c0faadc44ad6d4aff8e2bc37d69e"
    sha256 cellar: :any,                 ventura:        "842a9f48fd496ac4e30f930b7f5920d4df24173eb2ad05789e3d4454b4513a35"
    sha256 cellar: :any,                 monterey:       "daa4547eb65fe6b8a452d0b4dba7c917256303b8227020fd1c38bc443b28770c"
    sha256 cellar: :any,                 big_sur:        "0ee77de3211cec7de1019e5cbc223a091161e7a5ca1f4ce969d02006c3978ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eff7ca00f049cc932262893bb2f8ba8729e654322a93a1430ac9a21498a62a3"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  fails_with gcc: "5" # for C++17

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"
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
