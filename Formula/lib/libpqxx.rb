class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/refs/tags/8.0.2.tar.gz"
  sha256 "028c5fba4982e759fe182af1103ccd08b02bb4e1f9f12a551e01d21cac0c4440"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0d30cd49ad4b035df2f372c37c5f263247fea8708b18d0cda5ce8399a52f83db"
    sha256 cellar: :any, arm64_sequoia: "048591e09583cba17b6064712cac75a8593bb557b3c6a30f7d895789d06a6c71"
    sha256 cellar: :any, arm64_sonoma:  "1c59d26de230c3d9e72d14ac72b99401a3231a9e29e4df764a8985321ac101ea"
    sha256 cellar: :any, sonoma:        "01527e47ed423503e4c9dd2f9507fb54ad5295e7c1a96be250fc641b07a68f2a"
    sha256 cellar: :any, arm64_linux:   "3662aa967964766b3f42c7e04767e4a7743237d49551ef0fd1ab9086255407e1"
    sha256 cellar: :any, x86_64_linux:  "900be1f444a2ce2301cb3d7e58486c57316225ab467bba7caf26d1b8221aa2bc"
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
