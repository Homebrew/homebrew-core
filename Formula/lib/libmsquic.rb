class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.4.9",
      revision: "87c7ebebe8a5a4ccd1ecf412b24d384b4af4b71b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "84e5d7359f737cb77722fabac2e19a545ab3777fa2e9aa43169f92eb68dee123"
    sha256 cellar: :any,                 arm64_sonoma:  "173c940b2704bb3e6dccce808894b92989347078884d26836280c1578791a759"
    sha256 cellar: :any,                 arm64_ventura: "19b59d77c4df9f96f385b7a04ba03809bf2d695e72d7c67b16613d347e2be8b1"
    sha256 cellar: :any,                 sonoma:        "aa8452c428bcc907f637cd659272138d0b039d8254e8a22d2b75c94c6d8460f0"
    sha256 cellar: :any,                 ventura:       "60504af5663b0acca9d1d605eccce10fa0a407673a8ac931f6ea50d795f562e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4ac910748865447dfd1cbd036080a10189319db51c131ab3321bbea3ba044ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb8164a1fdcf276554b683b5af18d7f33e700adeb40f1b277d10f9d83b6f9c3"
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
