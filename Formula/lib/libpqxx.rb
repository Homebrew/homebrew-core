class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/7.9.0.tar.gz"
  sha256 "a1fafd5f6455f6c66241fca1f35f5cb603251580b99f9a0cf1b5d0a586006f16"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0544a6e77c53c081636c4ec66691c8b145dafb881a002f5d9dbccdb78561883f"
    sha256 cellar: :any,                 arm64_ventura:  "bec9d1600d861411dfa6fe8caeae9f75bba3ef966d7bd28210d870e225cc4113"
    sha256 cellar: :any,                 arm64_monterey: "99f9329816b3b984a5fc11be9c7a73eb257afd5b3e445f5c0b2b8e649a622d28"
    sha256 cellar: :any,                 sonoma:         "f912b2f89ef856d97c2533c368b3d98998bbaf13b07ac1bc6ed225880d16a87d"
    sha256 cellar: :any,                 ventura:        "7ca720a46c7737536b36714efe28718583745f5bae30b118440fbc27b5d1f1c6"
    sha256 cellar: :any,                 monterey:       "754eaaa867f534643bc3eb3d2315d68cf73795b9786d50c75f46ad667e8d4364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dc5225d4cc66f46baddf5692617203357fe5e4f91792fe3248574bc01e3e62c"
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
