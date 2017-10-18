class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.6.0.tar.gz"
  sha256 "0dfbfc2e5e82a6a7b2feca3d982d08fb7d4a979a4e75f667a37484cae4fda815"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d7821e53a9038af59c4cd993c63ebcd94127ee1bc84a59a750c77ea970ccaf2" => :high_sierra
    sha256 "955ba56deea5527160511e0f18ff757a53d1531a9cb1034ba20c5ef2e41d61fc" => :sierra
    sha256 "5586f79ecd99604a4c22781dd902529fed50320e4987ccc963bf7d2a6cd16e2f" => :el_capitan
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
