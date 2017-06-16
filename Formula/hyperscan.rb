class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.5.1.tar.gz"
  sha256 "a03288e62ba6f4c3c3ca7d0fbeb9286370d05e0674a81f18d19f4d129c6810cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4dd7b8ef28e31fe48330e9c37d999b81915f49556c6b87a1b0fc4882b3dea82" => :sierra
    sha256 "6f26b95487ee1a0373b81e8c62c656fb38e61d42064c6bcb92ca11a47f4e7f56" => :el_capitan
    sha256 "37d3e1ff1b217501026ee8a4701d2fa7bbe03f19603ab2261eb502a06dbbc6c5" => :yosemite
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
