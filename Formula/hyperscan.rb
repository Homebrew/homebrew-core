class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.3.0.tar.gz"
  sha256 "842527a578f58e4a8e441e6adbfd3a43667399125913ed5df20c72b94c9ccad7"

  bottle do
    cellar :any_skip_relocation
    sha256 "fce72d370fd54c6ebbd734dc8fb0f416279f866efe7d50f286a80c5ad92a901c" => :el_capitan
    sha256 "f22c23824462f248d10e9ef1a92ab0284b7acdd078f722d55fe0e314bbdab83f" => :yosemite
    sha256 "a1c74aabd1ee0f2539c23b324cc2360528d25d77a5cd5d223e2db3d71e8574b3" => :mavericks
  end

  option "with-debug", "Build with debug symbols"

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "boost" => :build
  depends_on "ragel" => :build
  depends_on "cmake" => :build

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
