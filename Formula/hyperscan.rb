class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.4.0.tar.gz"
  sha256 "e51aba39af47e3901062852e5004d127fa7763b5dbbc16bcca4265243ffa106f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 monterey:     "d042b40534ac02d2cc6ad57621802787340c7b76ee2bb7abfed79442b2f61d7e"
    sha256 cellar: :any,                 big_sur:      "1e75b4699ac1040d24cbe81ddae60149be7179e09f450840bdcbe5fd0e4582dc"
    sha256 cellar: :any,                 catalina:     "2c5afe9775aad01d1bfb577cb80218bdf241c48d5b567ad85fe6bba68241c8d3"
    sha256 cellar: :any,                 mojave:       "0564db4adcb7022d1691f482d12fdf3a2c0ea71079a749c90f2233340aebb98e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8e91525e2c275594bf2394e5664be60d6199784c9c2ab3b273a8531c38c2acc1"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ragel" => :build
  # Only supports x86 instructions and will fail to build on ARM.
  # See https://github.com/intel/hyperscan/issues/197
  depends_on arch: :x86_64
  depends_on "pcre"

  def install
    cmake_args = std_cmake_args + ["-DBUILD_STATIC_AND_SHARED=ON"]

    # Linux CI cannot guarantee AVX2 support needed to build fat runtime.
    cmake_args << "-DFAT_RUNTIME=OFF" if OS.linux?

    mkdir "build" do
      system "cmake", "..", *cmake_args
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
