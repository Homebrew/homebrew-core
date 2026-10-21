class Charls < Formula
  desc "C++ JPEG-LS library implementation"
  homepage "https://github.com/team-charls/charls"
  url "https://github.com/team-charls/charls/archive/refs/tags/2.4.5.tar.gz"
  sha256 "b55c742ef96b5e9d63f813a75d0ba29944302abb5a6ab59756ad61fa017b1dd3"
  license "BSD-3-Clause"
  head "https://github.com/team-charls/charls.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6f24c580dd9af1b9dd9e680edef59d026a5189c8a553f8c654a7756e32f799b5"
    sha256 cellar: :any, arm64_tahoe:       "64b8f53f9a0c638f6168f0e22ec9517a7b13beddcecab47d70ddae652788fd33"
    sha256 cellar: :any, arm64_sequoia:     "0dee7e1585e8c31b235fe7b33451496fea21cbf452fcd94674bd2e33adcc2881"
    sha256 cellar: :any, arm64_linux:       "41f30e444b2c3d75809d10a2717ae277c5d1725505f7e5dcf587d19b06f1b91a"
    sha256 cellar: :any, x86_64_linux:      "e4540a05130d1f6389e3c955827b60abbea45e65cf7904e2064249a0c10e0544"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
