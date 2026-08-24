class HdrhistogramC < Formula
  desc "C port of the HdrHistogram"
  homepage "https://github.com/HdrHistogram/HdrHistogram_c"
  url "https://github.com/HdrHistogram/HdrHistogram_c/archive/refs/tags/0.11.10.tar.gz"
  sha256 "c3b06d077e680d112abf9f027d8a558f1176ee4a55a7c523577833391d8c2249"
  license any_of: ["CC0-1.0", "BSD-2-Clause"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "82d614866ee4351be8d84502e69e74efb972fcaa55e2e77ea8eff259ee9f1d56"
    sha256 cellar: :any, arm64_sequoia: "ac019705090ca3db22752a5e5e6e1c15f0fcb325b23cb01149dc79cf225328ec"
    sha256 cellar: :any, arm64_sonoma:  "5b3c031677f867bb59289642df237f9b0461b3824cd1d8f54218916a6ff27a57"
    sha256 cellar: :any, sonoma:        "5a016888fa563bf94872596847b42628c6cdcc5e3b629e9acc9f9ba3e4a92285"
    sha256 cellar: :any, arm64_linux:   "a30dd526a00a0a501f182f9a363240b8a084315823988e62e317bfb6b2b2197a"
    sha256 cellar: :any, x86_64_linux:  "00929c5ef0d3a7c83956877411dfe888bf7642b3001678632f9c3c840bd207de"
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
