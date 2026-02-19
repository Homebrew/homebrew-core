class HdrhistogramC < Formula
  desc "C port of the HdrHistogram"
  homepage "https://github.com/HdrHistogram/HdrHistogram_c"
  url "https://github.com/HdrHistogram/HdrHistogram_c/archive/refs/tags/0.11.9.tar.gz"
  sha256 "0eb5fdb9f1f8c4b9c6eb319502f8d9e28991afffb8418672a61741993855650e"
  license any_of: ["CC0-1.0", "BSD-2-Clause"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d6176ee0c8f1da767cf07c9bc3f1481de19d9e500cafaa1896065ab2e5961cf9"
    sha256 cellar: :any,                 arm64_sequoia: "8e2ebaf0b19adeda703f29a398f06a370bfc26e1c491e5485581b897c376180d"
    sha256 cellar: :any,                 arm64_sonoma:  "4d62d2a9add2e38b3a446786b87a533fa5ffe737d32511cad60cabc60c81df66"
    sha256 cellar: :any,                 sonoma:        "890f9ac2df4f21715c3e14a8e3cc370004e8959268ef36246494ed4043be85b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5af92ae3629352a0e39691af319f65ca20108cf56acb807661408a63f57ef29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d7ecdf95eb22af3ba8e15175e25cf00a88ec7357171f96dfb9cf3d529528c4"
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
