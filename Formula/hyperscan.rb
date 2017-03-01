class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.4.1.tar.gz"
  sha256 "3a082d92a3cb0cd724bc1190d24cc39752bd3db35d22115fda03d2e91ccd94cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "95955960f7d59bbe2f8b070625773081fadcaff5ab4c8778e8ee6d85d84f551e" => :sierra
    sha256 "20643e8a08ee9a58807a82df3446b1223b653c01d9fd1310263c0289f0ab2051" => :el_capitan
    sha256 "178695ecc4b2f9d4bcacb81773a2584d1fbc8722258fe9b13f0fae8a3b3ccf19" => :yosemite
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
