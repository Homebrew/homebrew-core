class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.4.0.tar.gz"
  sha256 "e51aba39af47e3901062852e5004d127fa7763b5dbbc16bcca4265243ffa106f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, big_sur:  "1e75b4699ac1040d24cbe81ddae60149be7179e09f450840bdcbe5fd0e4582dc"
    sha256 cellar: :any, catalina: "2c5afe9775aad01d1bfb577cb80218bdf241c48d5b567ad85fe6bba68241c8d3"
    sha256 cellar: :any, mojave:   "0564db4adcb7022d1691f482d12fdf3a2c0ea71079a749c90f2233340aebb98e"
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
