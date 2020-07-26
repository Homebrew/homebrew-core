class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.3.0.tar.gz"
  sha256 "9b50e24e6fd1e357165063580c631a828157d361f2f27975c5031fc00594825b"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "a56dfd1232dd769b481e1c9e0544c84f542f82bb527e23dd27d9a7451258194d" => :catalina
    sha256 "217445aaf506df06e6759c53e38fc767c337a791a16d4073cf870027a93543f3" => :mojave
    sha256 "49403fbbdd395e877457945ce7f00476574befcfa07238059cfb8ee40ef8e764" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ragel" => :build
  depends_on "pcre"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_STATIC_AND_SHARED=on"
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
