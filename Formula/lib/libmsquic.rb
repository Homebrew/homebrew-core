class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.6.0",
      revision: "e7e7a114e20a55ec2d5f723cf6bdf3bfb7b0b24a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7f6bf364230410b5148e749b61910466c41977eb744d4a6d3c325d7ab90cd2b0"
    sha256 cellar: :any, arm64_sequoia: "cf99ce711231b21b79dcfc5afd1e7c21cfe62bfa8017300368455b6153731200"
    sha256 cellar: :any, arm64_sonoma:  "0358fa7671e1c62c1920bb1cd18dc9c24f66077cdfe1eb1daf79535e385c37e6"
    sha256 cellar: :any, sonoma:        "e31736904c5f9024858019febe8f3d5849c57f07871b629424e3c6c40a2c9dff"
    sha256 cellar: :any, arm64_linux:   "4ce71e44e4ea2eee733ad8a45e48240f14b3246b30ca02cf9ae2f9d14cc60ae0"
    sha256 cellar: :any, x86_64_linux:  "ea0b5aa7cf5d2aa2e07cd21d85dc5779ed08253b338b00dfe726ef712c214c75"
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
