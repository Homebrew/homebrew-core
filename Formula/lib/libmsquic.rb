class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.4.8",
      revision: "5ddc9bff4e82e910872fd239340e7970e3c768f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90acc20dfc3d26cf60ee882cd2cebc57d7e447fd36e1d11e327974afa85f272c"
    sha256 cellar: :any,                 arm64_sonoma:  "52fd7141b681884759501a67b598fa012d4e73e9d6a5e7283531278b2a0162bf"
    sha256 cellar: :any,                 arm64_ventura: "e38914d568131bcc9a5f439f55171a26a2063c8a5c3460023a09e9391bc8437e"
    sha256 cellar: :any,                 sonoma:        "254476756f0489eb7c0de3d9c874b78cd91eb1883efe9bc6af957ad608164e20"
    sha256 cellar: :any,                 ventura:       "5f8c13c6d5471a61efb5e11b79d5009524f69d9a90b118ffb6bb6a8f5da134aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8b005ebe32bda583e2753501a16940256212775fb2bc5aa34e95ed46cd4134e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55d6603b20c9ed8f76087c171b07ba721364bfa7ec3bcfb24dd992f205e046e"
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
