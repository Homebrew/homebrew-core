class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/7.10.2.tar.gz"
  sha256 "9e109ffe12daa7b689da41dac05509f41b803f8405e38b1687b54e09df19000f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed21501081fd8404fb8e8a4b550f0f9d958185eb1f6dec863c63e751cf6ba198"
    sha256 cellar: :any,                 arm64_sequoia: "96e2cb1bcd4a07516d7776fad1a5f95de023fc5248fbbb77757bb39d855a78a4"
    sha256 cellar: :any,                 arm64_sonoma:  "0dec7d9673083805891550a4de3bc04cc5cf386e37dbc5e40d4d6be8ff88750c"
    sha256 cellar: :any,                 sonoma:        "c37e557a9aec7bcb1a2003d756a74ed191e363c2f5a2d6fd47b39f5a075596ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86e04928947649716b353f5f09e76e97cca4fcba3ee403afc09ab15e2b02174d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7430a7b89c6992d6ce6deffda1d173b096bcae4ea10c7312ea100033a89a7d4c"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  uses_from_macos "python" => :build

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--disable-silent-rules", "--enable-shared", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
