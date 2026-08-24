class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/refs/tags/v4.6.tar.gz"
  sha256 "37a9cc407929c56c2081e717347cac455287ba354016bad5bad6243d1f0a4a7a"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/libtins.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f9dd0ceecbbd2b48bcff2ece82a88d8133b5634b832eb5cf85944b24c634417"
    sha256 cellar: :any, arm64_sequoia: "e7ea99156bc05bfd80c3ebbb119d773c5ea73204e176598ebfc9b514777b1009"
    sha256 cellar: :any, arm64_sonoma:  "1c06733acb014da750f46daaa0466b0ae466a942b25ac833983f5f896afafc39"
    sha256 cellar: :any, sonoma:        "68c16bbce3fd5e2ff19d5ed279a64d8ca9610f62369215cb7e9339f386991b12"
    sha256 cellar: :any, arm64_linux:   "67d8adb52d21249c3b5cb7fb4444a061aa5cf85bcdda828362dd99192967a1d8"
    sha256 cellar: :any, x86_64_linux:  "8ec6113b595cd5354418cc5243bed822f3be14340b7ce57074ec518af8f052c1"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  uses_from_macos "libpcap"

  def install
    args = %w[
      -DLIBTINS_BUILD_EXAMPLES=OFF
      -DLIBTINS_BUILD_TESTS=OFF
      -DLIBTINS_ENABLE_CXX11=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-ltins", "-o", "test"
  end
end
