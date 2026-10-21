class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "8584e3918f2e3c43c97b3c5ee036a14783581906d1b18d103982b1ccf54266cf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bb3958d0bc64d3759dcf56c49cfea7b7bdb141c9c08a34d7fed7d9ff1d7ec094"
    sha256 cellar: :any, arm64_tahoe:       "5a9a40b4ab6c8ee26b6232d2aa7baeb87758e2675fb96e213c71cf08f17d3efa"
    sha256 cellar: :any, arm64_sequoia:     "09b65a75f47cadd722cfa12e6892712da18c1cf36b0a0fea7d0404f6f652bfdb"
    sha256 cellar: :any, arm64_linux:       "0812d983e7d1d11444292bef8b1389135a25799320f96b4e96560856b9eedfa5"
    sha256 cellar: :any, x86_64_linux:      "6f370716adeca51b887862a0a82db56d590a9c8c8eab6e4b67801d3666a1055c"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    args = %w[
      -DQUIC_BUILD_PERF=OFF
      -DQUIC_BUILD_TOOLS=OFF
      -DQUIC_TLS_LIB=openssl
      -DQUIC_USE_EXTERNAL_OPENSSL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    example = testpath/"example.cpp"
    example.write <<~CPP
      #include <iostream>
      #include <msquic.h>

      int main()
      {
          const QUIC_API_TABLE * ptr = {nullptr};
          if (auto status = MsQuicOpen2(&ptr); QUIC_FAILED(status))
          {
              std::cout << "MsQuicOpen2 failed: " << status << std::endl;
              return 1;
          }

          std::cout << "MsQuicOpen2 succeeded";
          MsQuicClose(ptr);
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", example, "-I#{include}", "-L#{lib}", "-lmsquic", "-o", "test"
    assert_equal "MsQuicOpen2 succeeded", shell_output("./test").strip
  end
end
