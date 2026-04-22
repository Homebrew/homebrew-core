class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.5.7",
      revision: "801b0e958f3e33e9998766c3371c1ca348254650"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e91d792e7fb2cdbd0859431b8fe1b37c72669ced82a20f4c19ba1b49cc5aad5"
    sha256 cellar: :any,                 arm64_sequoia: "26e76f3305f7c88822c713ee0e1c3d6b91a49994191ecac841e50fab1f9cbbcf"
    sha256 cellar: :any,                 arm64_sonoma:  "34610cd55f97d90249bc7d887b1b9549c187a36c6dca44519826336690bc0a93"
    sha256 cellar: :any,                 sonoma:        "15f897b07a910acab7e9ad46012553abab9fae31075ef8d7060151c199dec054"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1034c37085d2416458dc4ec293bbe03672454a26140f23f0eba077bc77b41432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a044b1acfc739b5b9be960c59bbdf3e60281de617290bd22b873dc8174d5ff"
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
