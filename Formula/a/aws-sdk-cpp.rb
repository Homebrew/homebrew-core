class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.929.tar.gz"
  sha256 "8963f5c5b52c5a9bde6e0320d766f72cf65d7e04434a24dc9a34c593501b05c8"
  license "Apache-2.0"
  revision 1
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "587c086f14c9bcb593a22ebfa5c4fded2e712b6b740014f295b26ee73f410430"
    sha256 cellar: :any, arm64_tahoe:       "e6492d98581ec13dd9b870597331d0c10a546c8ef920b699fc5ccd0f3c36abbc"
    sha256 cellar: :any, arm64_sequoia:     "24d2437acff939f89fe07d3b1760e14ebbede0fa3095e5f641b38494db007f9b"
    sha256 cellar: :any, arm64_linux:       "5972c4a0659be8b5f817aa14fcd2587e8b745d39cdf149da09dcfb98465dffe8"
    sha256 cellar: :any, x86_64_linux:      "99dc5ba5920a50e5204f356af788d604925928e7e7ad1b75601ff6cb0224bbc8"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-s3"
  depends_on "aws-crt-cpp"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    linker_flags = ["-Wl,-rpath,#{rpath}"]
    # Avoid overlinking to aws-c-* indirect dependencies
    linker_flags << "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %W[
      -DBUILD_DEPS=OFF
      -DCMAKE_MODULE_PATH=#{formula_opt_lib("aws-c-common")}/cmake/aws-c-common/modules
      -DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}
      -DENABLE_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end
