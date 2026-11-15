class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "08dac7af2cebb41460d0b716dce82c9c923149b8f29ea6d32321c8794c440994"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "613b117d8adc63e6f64d1b4beaa264d426b270e3e40dd19fadee5afc958be6f3"
    sha256 cellar: :any, arm64_tahoe:       "a3853bc0917d488930b0d9f89e5c44713924d20dac582b1d8c490905b6568808"
    sha256 cellar: :any, arm64_sequoia:     "91ac4ff117ce9617b229b06f8aa4e66b005203462fcb804586831c148d57c782"
    sha256 cellar: :any, arm64_linux:       "956be08eae4baafc8995ca3f9d228cdd79a8a01492be8b0e10a05f3dc9add28b"
    sha256 cellar: :any, x86_64_linux:      "812e318ff272e67bd6c6ca93f9ecf763cfc305a29140108f461df85de064eef2"
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
