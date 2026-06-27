class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/8.0.1.tar.gz"
  sha256 "24f878a1b4249035e4b6c07d49351506bf99f88df584d36bf198d58ebf293823"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "74bd7251500d9ac5f524882e2be5b8cbe87f5e0b487d0166ddc46359fcaf2543"
    sha256 cellar: :any, arm64_sequoia: "bd1693c778322338101c88fdcc06e2b46ae3beb1492b80ab19507231a2701ffa"
    sha256 cellar: :any, arm64_sonoma:  "92bc90091b0e175626488aa9efea6cd65635633bb6ee6b9fc3fa4d8a9702f340"
    sha256 cellar: :any, sonoma:        "0ebf76a99e37fdc0d41565ab8a5e5b820c7c68e412d6874d937fdd1f8647f7d5"
    sha256 cellar: :any, arm64_linux:   "0451b37525134aabc4b82880f09feccf9136bb5d77ffee435d96e08a3097dc03"
    sha256 cellar: :any, x86_64_linux:  "b2359b444e05795b3eba91929f48df79b3e259bb26dcbe20a180df25424f5660"
  end

  depends_on "cmake" => :build
  depends_on "libpq"

  uses_from_macos "python" => :build

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSKIP_BUILD_TEST=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++20", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
