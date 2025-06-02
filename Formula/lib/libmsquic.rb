class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.4.11",
      revision: "18b58030a1aee72d94d705d5738cfb87650b063a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89bbdc9b1db3f643d9f223538b09cbf0b4bb1133c662630e65430db4692a94ae"
    sha256 cellar: :any,                 arm64_sonoma:  "8325d65147aec0bda760fff3877c7a5906317d15f49f21c644e8fd994ce749ee"
    sha256 cellar: :any,                 arm64_ventura: "1fcbd01c40f6eec8d01052e3635e61af732e8fae1f53ad4e1b1125ea119819e3"
    sha256 cellar: :any,                 sonoma:        "3eac3ea81c90f349167dcacfdfc2f98447f700c297f8060d5f4f7f302aaf6147"
    sha256 cellar: :any,                 ventura:       "f4a98a03a312f0cb685d111690cd7687bfc15250d22d768e642b69528b11d4c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c01a5f417fe2d51b8f21803595b2091745d2eeb0f5ab0653ecc9c836ef17ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d79cb6eaecbe706a86c2a93feb7f45841395d5a2ee2ab7101f5570e77c2482a"
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
