class Charls < Formula
  desc "C++ JPEG-LS library implementation"
  homepage "https://github.com/team-charls/charls"
  url "https://github.com/team-charls/charls/archive/refs/tags/2.4.4.tar.gz"
  sha256 "fbd712903d61306ad00d5fa5029a9882630c7311ca487f48d2d76000956e8ff9"
  license "BSD-3-Clause"
  head "https://github.com/team-charls/charls.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d0a67e9b45f8d59b907a1cb48a1e06d54a53255ebd86d665e9bbdffef19ee108"
    sha256 cellar: :any, arm64_sequoia: "014a6e667c1572a3ce331484fa512459093b48af7d43ec709d340d3694f19538"
    sha256 cellar: :any, arm64_sonoma:  "31a404ff9ea71c0b6f8abc603dd8e7282a5ac81d24ae5d8f1aa7a6f7edcc6de9"
    sha256 cellar: :any, sonoma:        "02610dee00fef9b3dea8d0e7df1a5c703959ec47a6c2a57c31ef1947759e6cea"
    sha256 cellar: :any, arm64_linux:   "25253e5341b7507f2e12b6a4e9a80d02dbd65e3f931bfd425a5655511a388827"
    sha256 cellar: :any, x86_64_linux:  "a8ceb4a16f10f2915c862c0f5b439bbb51567087a5b6f81acd52d26c06945d1a"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCHARLS_BUILD_TESTS=OFF
      -DCHARLS_BUILD_FUZZ_TEST=OFF
      -DCHARLS_BUILD_SAMPLES=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <charls/charls.h>
      #include <iostream>

      int main() {
        charls::jpegls_encoder encoder;
        std::cout << "ok" << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-lcharls", "-o", "test"
    assert_equal "ok", shell_output(testpath/"test").chomp
  end
end
