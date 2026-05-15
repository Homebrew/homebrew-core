class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.5.8",
      revision: "bf10e4a60dd03c471343623eccd35b4ea671937f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db4983b53d42728b269d454b9c15ddb8a1a9f8fd175c47284c38ac0d0c057c3f"
    sha256 cellar: :any,                 arm64_sequoia: "8ae7bfade1dbf4e5899dad6e492103af2b78d781f98181e4969fc4a7211651f0"
    sha256 cellar: :any,                 arm64_sonoma:  "0ca66c8ed9d7d8d4b86e41ac93bbed9e60956d8ae6baddaad1132ebe61fe5d6b"
    sha256 cellar: :any,                 sonoma:        "ce8ee9c89975a16267be6e3dec745b82b91ada68d463b8572df31b418f3e6c49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf675bed2e5f13b273020f19a758d863ab7237d0ad21d45f111b0da90e119ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a38a3b3d7d11b227b4b6dc415bb07e638be204a8f896c88f6d8b7cb03a1f41b"
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
