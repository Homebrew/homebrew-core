class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.5.9",
      revision: "87b53085d76bd7920d490a6f226c9999b6614d14"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5130216f4954b40d414349e8ac303d0c0c3c405a2489eb166875aba5475367f1"
    sha256 cellar: :any, arm64_sequoia: "df3c43090c61892bce44e4fd7ae0bd4f000ff47431b3a8b9b4e245d6039a2d1a"
    sha256 cellar: :any, arm64_sonoma:  "b4e7091e310ce7a9a3b0472973a84a3a0c1ebbbe714f3f359579d5c9c0a51774"
    sha256 cellar: :any, sonoma:        "9ded86f059eb73dd28382f39816d940609e4278327f412567b5dae5dc2efc4df"
    sha256 cellar: :any, arm64_linux:   "a8a010db6dad513a8f1abd24b5ae885d16270ad4520e83b15f4a5fab5042961a"
    sha256 cellar: :any, x86_64_linux:  "c6d48d5f1057efbf710882947de80108eda7d82b811dee2b4c5db95abdb88b9d"
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
