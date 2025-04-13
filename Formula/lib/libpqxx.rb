class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/7.10.1.tar.gz"
  sha256 "cfbbb1d93a0a3d81319ec71d9a3db80447bb033c4f6cee088554a88862fd77d7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69a1b8a5ca5b3dbef5c4d8d2e5551951f94b9d14a0764923d187c47248f05f76"
    sha256 cellar: :any,                 arm64_sonoma:  "a2d7f9df60c26e02077ef4e75fa056f462ecb7f246289d0b286037ec5f21d0cc"
    sha256 cellar: :any,                 arm64_ventura: "3ad77f64389847790537623eb4d13ba241382d47720888c7ec494bc716bbd026"
    sha256 cellar: :any,                 sonoma:        "2a14042a342c722b41854636513e97561592a584e0df9f9092285d33590888cc"
    sha256 cellar: :any,                 ventura:       "3068d9da7e7738e52292fa050ad17da295374c1a1e7da2d5c79a2b42f08a1b1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b3888afb0a0301fd3cab111d947e3c8c341a98f704a8e98ac6a5a2b78613bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2736a2bc32c9f4cadacd4c0175680b9526b6a9250509747e96627da395bbd0f"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  uses_from_macos "python" => :build, since: :catalina

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
