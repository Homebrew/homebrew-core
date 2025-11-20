class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.5.5",
      revision: "a69c9e9ef0612c1dcc1913d5643d3d9b3ac31cf2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d014246773632be60106169cb770a5371093823d76b7fbe66313ffe20e217ed7"
    sha256 cellar: :any,                 arm64_sequoia: "5877f19242d6b222b572c42ae3de35f897076bf5241cce56bc8d3ec6222e16d9"
    sha256 cellar: :any,                 arm64_sonoma:  "a75cd5a258c4dcb81086b67423b0bb415f8b9b2027018ed1f7a1d84b60703d21"
    sha256 cellar: :any,                 sonoma:        "e36a8c8fdc6ec83b9b486ef7c28a3ff32d70f064d6eeea08fa0596a9506f15fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75be0f906ce58a4f63f6af8bc663774edfa6f8538f5285efcb8998bf2213156f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d7e618fb38df8627514a4d4201f4275b38c9a9d777ebdafe4b64f445d92185"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    args = %w[
      -DQUIC_USE_SYSTEM_LIBCRYPTO=true
      -DQUIC_BUILD_PERF=OFF
      -DQUIC_BUILD_TOOLS=OFF
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
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
    system ENV.cxx, example, "-I#{include}", "-L#{lib}", "-lmsquic", "-o", "test"
    assert_equal "MsQuicOpen2 succeeded", shell_output("./test").strip
  end
end
