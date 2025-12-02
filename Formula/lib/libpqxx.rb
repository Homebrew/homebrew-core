class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/7.10.3.tar.gz"
  sha256 "c5ba455e4f28901297c18a76e533c466cbe8908d4b2ff6313235954bb37cef25"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91c06fabfc19493b74ff6c9d98cd4e725e39e1ad2226de8b004cc53da34423d0"
    sha256 cellar: :any,                 arm64_sequoia: "6feca803d2051b747872573c6aa5f7fb4e4e82f68c2ce1702cb62306e519c707"
    sha256 cellar: :any,                 arm64_sonoma:  "7dfa29f9b24b84fadbcff707da41678bbf5a89e509f8d596b0fb18622d4e6387"
    sha256 cellar: :any,                 sonoma:        "b88b53fd6a80281c12f4814eb890c6aba651d1ca677dd4c35d0dcecaf1f90ad2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "311d05aa40fd590772075c752c99961319a64fadfa8a41d257c2a12e3f33a6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a5d4342e18c58adcaceaebb502c91cbb301daf71642afc306fca9bb420c386"
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
