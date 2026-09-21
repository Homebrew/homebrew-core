class Libmsquic < Formula
  desc "Cross-platform, C implementation of the IETF QUIC protocol"
  homepage "https://github.com/microsoft/msquic"
  url "https://github.com/microsoft/msquic.git",
      tag:      "v2.6.1",
      revision: "a01333cf7c2659cce0ff03ef3f21e1ff15bb5b83"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b0600f8562dffedd91191a33ccdb18d45578a986893ddd7fd11014602ae87c23"
    sha256 cellar: :any, arm64_tahoe:       "bb9557aa2f1c15030883efabb8d4fd714aa197c34d92050bb0eed3e30b059558"
    sha256 cellar: :any, arm64_sequoia:     "eb965abad227fe87e784f9e2009c960d08f398f5fecac1acbdfc90fe6034df27"
    sha256 cellar: :any, arm64_sonoma:      "7240014c3758b61e502cf50d29d81193ffcb5527808fe77f36e2020fc8d54f02"
    sha256 cellar: :any, arm64_linux:       "7aa5a4163ea76a9dbfd895cae12b3ed8d79735354a80e2b662840d2be9807032"
    sha256 cellar: :any, x86_64_linux:      "c0f526d7285b0ad2dbb1b536f30a5ae69a91597598021a699501010b8d9da19d"
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
