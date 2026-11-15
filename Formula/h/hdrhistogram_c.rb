class HdrhistogramC < Formula
  desc "C port of the HdrHistogram"
  homepage "https://github.com/HdrHistogram/HdrHistogram_c"
  url "https://github.com/HdrHistogram/HdrHistogram_c/archive/refs/tags/0.12.1.tar.gz"
  sha256 "b2cff564b49f900e7f951c95428100a4aed36561703237ffc5e41b4843d804ce"
  license any_of: ["CC0-1.0", "BSD-2-Clause"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1aadec5ca79aaa35ac1a23a67d68b5890d2c94da125ee9ad3b7d6412770296c1"
    sha256 cellar: :any, arm64_tahoe:       "4fabc58a96b5d3444a23dfdb3963aa6d8b30ce7939ee445b01891822e9236726"
    sha256 cellar: :any, arm64_sequoia:     "9ac2a2b0243ba0f796abfb23928e0362fbaa1b447354bb24b63fb96c901d0ed2"
    sha256 cellar: :any, arm64_linux:       "3af4fb4d544da1208e4544b933d318808e7dd0dbbc35bb309bc39afcebcab416"
    sha256 cellar: :any, x86_64_linux:      "5c10dd53f8f44d1ae7ef10a0ba3247c159b810a418b3a232d447a394289125c3"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DHDR_HISTOGRAM_BUILD_PROGRAMS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <hdr/hdr_histogram.h>

      int main(void) {
        struct hdr_histogram* histogram;
        hdr_init(1, INT64_C(3600000000), 3, &histogram);
        hdr_record_value(histogram, 2);
        hdr_record_values(histogram, 4, 10);
        return hdr_percentiles_print(histogram, stdout, 5, 1.0, CLASSIC);
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lhdr_histogram"
    assert_equal <<~EOS, shell_output("./test")
             Value   Percentile   TotalCount 1/(1-Percentile)

             2.000     0.000000            1         1.00
             4.000     0.100000           11         1.11
             4.000     1.000000           11          inf
      #[Mean    =        3.818, StdDeviation   =        0.575]
      #[Max     =        4.000, Total count    =           11]
      #[Buckets =           22, SubBuckets     =         2048]
    EOS
  end
end
