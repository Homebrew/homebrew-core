class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.3.0.tar.gz"
  sha256 "842527a578f58e4a8e441e6adbfd3a43667399125913ed5df20c72b94c9ccad7"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dfa67df172bd561c0273e59f30b02064467ddbde0f4f37ae5e000efdc0d98f5" => :el_capitan
    sha256 "4b9ffad5a523b83dc7a6c5379d201c55becad69eec015767edfd29e205fd4429" => :yosemite
    sha256 "712456308a7cf5216752036b9d7ae535ae814f865099ff0436689eafcbebc085" => :mavericks
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
