class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.4.14",
      revision: "4922536a9b0b5d1d5c14f907eb3bd0977201123d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80bfb050fcff4786acc6f586cab146f7d9393a155f903524b14697c1440a093a"
    sha256 cellar: :any,                 arm64_sequoia: "c47a15dea5086c543f5e151ebc0c1c7f81a35efdc92afad98b8831b44e693cbc"
    sha256 cellar: :any,                 arm64_sonoma:  "a015334cbb4a87a0cb7eb21f907dec2d437b179762b3cfa2849ae45945f19a52"
    sha256 cellar: :any,                 arm64_ventura: "9b968e4192831d8e8cfba5d3a84c56dfe7db39ccbada6e32f453a9925a648b28"
    sha256 cellar: :any,                 sonoma:        "2f2f1e22172b185c48d21d5e98cf5bf0e0f86781148e295987f71e72fd4ba65e"
    sha256 cellar: :any,                 ventura:       "27f75a074b84c50563b478711d53ee480a979a3f5484f99d11d97c5e1eacfb82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99cab09d054f40103082ead4ea8cac669ff142cf9f15680eefc6646609226e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ee627835230cd6187ece4469c346e5f12805b4490b7011e1b576a3f3dae474"
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
