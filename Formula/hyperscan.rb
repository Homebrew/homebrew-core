class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.6.0.tar.gz"
  sha256 "0dfbfc2e5e82a6a7b2feca3d982d08fb7d4a979a4e75f667a37484cae4fda815"
  revision 1

  bottle do
    cellar :any
    sha256 "fadbdf51c42c8f92cd01855a5d86b0e82d07a4d6d58947f75ccdfa33eda0bb9e" => :high_sierra
    sha256 "a6f6024a82bb228fc1a4a614bcef3efc9708c57198c6a3325969743d5843b0bb" => :sierra
    sha256 "5e2c55a40cd4db79364debd0bfbc7ec01dac5d079f11a8896aee81be3e16d3ed" => :el_capitan
  end

  option "with-debug", "Build with debug symbols"

  depends_on "python" => :build if MacOS.version <= :snow_leopard
  depends_on "boost" => :build
  depends_on "ragel" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    mkdir "build" do
      args = std_cmake_args << "-DBUILD_STATIC_AND_SHARED=on"

      if build.with? "debug"
        args -= %w[
          -DCMAKE_BUILD_TYPE=Release
          -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG
          -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG
        ]
        args += %w[
          -DCMAKE_BUILD_TYPE=Debug
          -DDEBUG_OUTPUT=on
        ]
      end

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    system "./test"
  end
end
