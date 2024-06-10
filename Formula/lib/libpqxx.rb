class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/7.9.1.tar.gz"
  sha256 "4fafd63009b1d6c2b64b8c184c04ae4d1f7aa99d8585154832d28012bae5b0b6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c72288d3eb74baef46fbc6d31f499184a0f10cb02b866236b78dc5d5156f6c01"
    sha256 cellar: :any,                 arm64_ventura:  "98c39e3e7971fe158745396dcaaa38e444f842f716130c9c15782d97664687bf"
    sha256 cellar: :any,                 arm64_monterey: "79665699af0eaf02a53fe617d26b37218b0a11f9427e240dc480ff35d564f199"
    sha256 cellar: :any,                 sonoma:         "ffa64497885ee9cf3de22c75806cc7d1fb955cd49b7da7ba431a7857bc1deddc"
    sha256 cellar: :any,                 ventura:        "0d14881459f82dcb4a2c8e93a186e4578e1ecb04d12d6b5c50d3cde57378236d"
    sha256 cellar: :any,                 monterey:       "3f00ce8855eb2b1e35e92f729ce788e716e588aa8a44b24c8b96a2b0ad967a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52ceca8c48b132ba3f52e8f1a14c9b0ee2e9e88360c3a648ffd4a8138e1a7a6c"
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  uses_from_macos "python" => :build, since: :catalina

  fails_with gcc: "5" # for C++17

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--disable-silent-rules", "--enable-shared", *std_configure_args
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
