class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.4.7",
      revision: "622a72573000fef2400b12097f5011b2c5657f5e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ae84e481cf520b7f5e796cdb23d798b77c4a75c1514c1efeecb9ba75402c8b43"
    sha256 cellar: :any,                 arm64_sonoma:  "990b3c4a37baeb3968a5f15b08fb8b0765a0fd50e12f549128d39b94a55ba217"
    sha256 cellar: :any,                 arm64_ventura: "e29cb2058af5c07ce360c207ef73d815a74ae1a732ff021d4bd02972a68b60e4"
    sha256 cellar: :any,                 sonoma:        "3410cc3a1462e5f8b8838d88eb5a8eaaebd766e4080606eca76af0cebf779952"
    sha256 cellar: :any,                 ventura:       "2bb02eafb9f8a22cdd4a3c2e585d044900992228ba7831d8688d9f9f11113e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ea9ad1b92b59ee9cff735cdf8168c16c43ffe2f961b310babafaef444dc64a"
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
