class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.5.0.tar.gz"
  sha256 "b56973ee9cbc0d1e732c8f9daea61256ac8424f65b74addde540b0c35265ba8a"

  bottle do
    cellar :any_skip_relocation
    sha256 "76f697bd8a976f80642ba826d3b8a6656d9531076a198d67856238c6b77632c8" => :sierra
    sha256 "900368f5cd3b4aa0f04240138572b6d53c467f83489005242974bb7726528a69" => :el_capitan
    sha256 "4a952f8bc7b5c4f1df39a1ba1be0fb92d06fda0869b64af3c817de39311d7239" => :yosemite
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
