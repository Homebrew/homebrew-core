class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.3.1.tar.gz"
  sha256 "a7bce1287c06d53d1fb34266d024331a92ee24cbb2a7a75061b4ae50a30bae97"

  bottle do
    cellar :any_skip_relocation
    sha256 "98c09016eae2cd8ac7b757efd97dc13b25577d993b5c2a33892ba07060d38834" => :el_capitan
    sha256 "51a0f38350e24d8c45e39504c604e2af3b4cbfa8d3db339864cc84cf19366edb" => :yosemite
    sha256 "10d6c0f07c56d706c8c568963e937fa96bdcd7d2117cadb64046210c8b1235ab" => :mavericks
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
