class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.5.2.tar.gz"
  sha256 "1f8fa44e94b642e54edc6a74cb8117d01984c0e661a15cad5a785e3ba28d18f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "25b22c4dcc4e02b0d7b54ce3073dcefc422d23457e0d69ef1c6439038e199cb5" => :sierra
    sha256 "dff3532e3f36b3aa64973b96cc44d5b6a7026566170411b4255ac698ca3e1e50" => :el_capitan
    sha256 "7c7f0655a30146c24680ebcbaf663f87d96446abf995dadcfb55b905eebe6d7c" => :yosemite
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
