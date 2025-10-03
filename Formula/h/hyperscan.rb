class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.intel.com/content/www/us/en/developer/articles/technical/introduction-to-hyperscan.html"
  url "https://github.com/intel/hyperscan/archive/refs/tags/v5.4.2.tar.gz"
  sha256 "32b0f24b3113bbc46b6bfaa05cf7cf45840b6b59333d078cc1f624e4c40b2b99"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 sonoma:       "2019ecd836e8e16a4b4a1e2605297900ee9d5e6ca8fce4c2cee056ea8c00934d"
    sha256 cellar: :any,                 ventura:      "a5866b950b8b18122c144b6b6ff2ca64705861d59917a1762bef1faff1cc7b8a"
    sha256 cellar: :any,                 monterey:     "d67efe0abd515b90c2fe9e10694c99f62e708ac507395aa232bbb54eac0470b6"
    sha256 cellar: :any,                 big_sur:      "f000309c80201f6a1ced867c4d36d45a51ea980cd3ee116e853cf03625efcc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "45406945a7c9c98bb01d8dc90ad045746bbe7b0146a522badbc8925dd03d0fd5"
  end

  # This software is no longer open-source after this version,
  # and the upstream repository is not receiving any updates.
  deprecate! date: "2024-05-10", because: :unmaintained
  disable! date: "2025-05-11", because: :unmaintained, replacement_formula: "vectorscan"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ragel" => :build
  # Only supports x86 instructions and will fail to build on ARM.
  # See https://github.com/intel/hyperscan/issues/197
  depends_on arch: :x86_64
  depends_on "pcre" # PCRE2 issue: https://github.com/intel/hyperscan/issues/397

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_STATIC_AND_SHARED=ON
      -DPYTHON_EXECUTABLE=#{which("python3") || which("python")}
    ]

    # Linux CI cannot guarantee AVX2 support needed to build fat runtime.
    args << "-DFAT_RUNTIME=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    system "./test"
  end
end
