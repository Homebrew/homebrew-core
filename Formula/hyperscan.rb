class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.4.1.tar.gz"
  sha256 "6798202350ecab5ebe5063fbbb6966c33d43197b39ce7ddfbca2e61ac5ecb54a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 ventura:      "f0105513ef5f4258bea80ce4d66fdc58870ade37549098c5a7ef695c02e2c21a"
    sha256 cellar: :any,                 monterey:     "38d912db872b46ddd8242f543e343b4a8a47c98d2900e6dc7b9a1e80fc8f9141"
    sha256 cellar: :any,                 big_sur:      "4d712c27745f4c175051fc4b753b990b70f2108858ff3620f1e928aee8666753"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "01a5210d8c7b25dc9029a3f3b97fee837c22f4fdfa53d41e94d5d258d9180550"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "ragel" => :build
  # Only supports x86 instructions and will fail to build on ARM.
  # See https://github.com/intel/hyperscan/issues/197
  depends_on arch: :x86_64
  depends_on "pcre"

  def install
    args = ["-DBUILD_STATIC_AND_SHARED=ON"]

    # Linux CI cannot guarantee AVX2 support needed to build fat runtime.
    args << "-DFAT_RUNTIME=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
