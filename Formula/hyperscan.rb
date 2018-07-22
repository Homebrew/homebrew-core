class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.0.0.tar.gz"
  sha256 "f2bdebff62a2fc0b974b309da7be4959869fb7cababe1169b7693cfd672c2fe0"

  bottle do
    cellar :any
    sha256 "7e640d067a206edb90c3023ccd4cf14156238f3f09bf902bac89f0ce2e4163e0" => :high_sierra
    sha256 "98f8ba279281bcb14437713eb237e69a5680fe33d2e4da2173a1d4e6b70ae8c2" => :sierra
    sha256 "48b0fe0011be4d9853f22d226a5a9ae7c5ddacb2cb30106673a07db526d1cc67" => :el_capitan
  end

  option "with-debug", "Build with debug symbols"

  depends_on "python@2" => :build
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
