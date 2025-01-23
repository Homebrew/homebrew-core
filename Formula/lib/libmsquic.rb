class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.4.7",
      revision: "622a72573000fef2400b12097f5011b2c5657f5e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2b2f6837e911856a5aeee49d322e4dc1d63000d55a2b6403702b6f58075ba42b"
    sha256 cellar: :any,                 arm64_sonoma:  "fd2b7a19b194f60a16a0a92751a4ecf79c8c36fa918f0589803814c1974a5e17"
    sha256 cellar: :any,                 arm64_ventura: "50914e7db8dd09e19f3cd7c1ed048319ca6683a6166e73f034a34d8de68e0e60"
    sha256 cellar: :any,                 sonoma:        "f69bdde7657ca164673c7a701e11836cfef18df7df19b1978471895810ab5019"
    sha256 cellar: :any,                 ventura:       "ebafc94ba6d2f3c9c3f5ca65a3cea2b7275d1611c4c64614b7137432fbd99465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5067ecdfa0af223939dc3c838521c4894bd89cdb29b8d50171d80ebd69eac7"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    args = %w[
      -DQUIC_TLS=openssl3
      -DQUIC_USE_SYSTEM_LIBCRYPTO=true
      -DQUIC_BUILD_PERF=OFF
      -DQUIC_BUILD_TOOLS=OFF
      -DQUIC_BUILD_TESTS=OFF
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
