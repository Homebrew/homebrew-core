class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.5.6",
      revision: "ac83e946bba303901dd34ff3d1d772e4c4061f1e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8044efd74b4fca0eaa4d7648c94c44d0ebde1221629683b0f74c37f616bcdc17"
    sha256 cellar: :any,                 arm64_sequoia: "cfc8cb9139507fef2f40d24aba328fc989d32f35069cf96a4e22890a48e7d7bf"
    sha256 cellar: :any,                 arm64_sonoma:  "2db7c0740850b8044cfd958bb81ec9cf62097129fbc2488b47bb64a9a3163bc4"
    sha256 cellar: :any,                 sonoma:        "c6bc79b3ac975ff46a18a80bf642d4323ed7cebb4b1bb8dc01eee79fd0af2179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93bf37ef8dd364ca1039605ec16edf1a21b492644b384f339ce6a03ae8b41c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f939b9f98ee8510746ce2bddec5060e6d8671ee8c4b68e6303d33ac9369354c"
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
