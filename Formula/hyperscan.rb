class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.4.0.tar.gz"
  sha256 "6ff1b47ce9888803ce6dfa8e1efbab30ec53f984410275d7a45138825af0a0d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "60c473e1af60905f5de69f4ed425527355fa628b550b01d535d21c157cfd9289" => :sierra
    sha256 "57f1248ed0d3968f94df20d6b619898b04f29899030eb6a6875d9398b6bae665" => :el_capitan
    sha256 "d5bc8b69070850a7b10dbb879e83c1091c00cd5ed5301d635259227f99bfc328" => :yosemite
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
