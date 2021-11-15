class FlowTools < Formula
  desc "Collect, send, process, and generate NetFlow data reports"
  homepage "https://code.google.com/archive/p/flow-tools/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/flow-tools/flow-tools-0.68.5.1.tar.bz2"
  sha256 "80bbd3791b59198f0d20184761d96ba500386b0a71ea613c214a50aa017a1f67"

  bottle do
    sha256 arm64_monterey: "f777ff9ec4f45fac84b06bad2fce24a144fd7c0df2b83490852139edf12b4977"
    sha256 arm64_big_sur:  "81f57d2bc6154643b3836e02200b77573cfda8f16abe9d6c7575f24f35c74048"
    sha256 monterey:       "f6118db5b348d619d01bafffe2f6f71d962b66f3a926ed77a6998da0dc327018"
    sha256 big_sur:        "9884c67cdf4c5aedd39ce946d68bcc8a090e01793fac68b89f6dd7933d55c945"
    sha256 catalina:       "b2cf9a7d6690c11dd5894bac2e38175d599341ee18dcd99a3e1185f8d8cd8995"
    sha256 mojave:         "6246a56252302b21018488ffe774cf5a203c373b1b5a4876a2d70d7d6b0cba20"
    sha256 high_sierra:    "be6a9b7233b78e61df362ab06916a1912b1ac197f39849081cd3d9ca4cda5c31"
    sha256 sierra:         "47ae55656be935936a5d3aa505f510c337818bd3c9d1a7fb028044523382dd8b"
    sha256 el_capitan:     "2b41c1415b50e7123c5268dce7c656aba825a16c061691ee8eaf06e39d622cec"
    sha256 yosemite:       "0d3814f50d6bc8d06c808176bc0b6f725f429b231a21eabe49fadf6729a7d27b"
    sha256 x86_64_linux:   "64da4b6f7a1bb388ab05c1d258e2083f5e6601ad3e93b2330313abb8a5b2b72b"
  end

  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Generate test flow data with 1000 flows
    data = shell_output("#{bin}/flow-gen")
    # Test that the test flows work with some flow- programs
    pipe_output("#{bin}/flow-cat", data, 0)
    pipe_output("#{bin}/flow-print", data, 0)
    pipe_output("#{bin}/flow-stat", data, 0)
  end
end
