class Libbsc < Formula
  desc "High performance block-sorting data compression library"
  homepage "http://libbsc.com"
  url "https://github.com/IlyaGrebnov/libbsc/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "b0081d225f6e5e1bac50d16ad4a784ca48cb28b1f0f4fd90a10310725c7e6d7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6cccb29159e112885451bcbf19e94c7aa875ed88bb5f4881927d9e49c26683db"
    sha256 cellar: :any, arm64_tahoe:       "a07dac17f47d40b36d2639f235de5902e975223fe005b50ce2d7c994d878bdee"
    sha256 cellar: :any, arm64_sequoia:     "7a85f7743df3f388e4d33c4b84dd001b345be288475352d864acb70d581e77d5"
    sha256 cellar: :any, arm64_linux:       "611b63138efd09fb7450ebf4f3b65905896010d2b559522c704f5133738b9ec5"
    sha256 cellar: :any, x86_64_linux:      "2e56afad779c5e241a7ed939fb96ea4b940e12e7b29947286a3be161a812c76a"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "bsc", because: "both install `bsc` binaries"

  deny_network_access!

  def install
    args = %W[
      -DBSC_ENABLE_NATIVE_COMPILATION=OFF
      -DBSC_BUILD_SHARED_LIB=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"bsc", "e", test_fixtures("test.tiff"), "test.tiff.bsc"
    system bin/"bsc", "d", "test.tiff.bsc", "test.tiff"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.tiff").read),
                 Digest::SHA256.hexdigest((testpath/"test.tiff").read)
  end
end
