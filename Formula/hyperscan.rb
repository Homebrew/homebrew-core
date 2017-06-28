class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.5.1.tar.gz"
  sha256 "a03288e62ba6f4c3c3ca7d0fbeb9286370d05e0674a81f18d19f4d129c6810cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a73c90f71e8f2735fc9d5f66e28a41b798642b3eec0f691d3614c833958c012" => :sierra
    sha256 "078b9eb219a0533d1ac1685b0beb649570effd9a5d600086cd571970d19b65db" => :el_capitan
    sha256 "71fbcec69831cbf6a848c888f045da122f6a2449b13b5302ef536cc1a0904f52" => :yosemite
  end

  option "with-debug", "Build with debug symbols"

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "boost" => :build
  depends_on "ragel" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    mkdir "build" do
      args = std_cmake_args

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
    (testpath/"test.c").write <<-EOS.undent
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
