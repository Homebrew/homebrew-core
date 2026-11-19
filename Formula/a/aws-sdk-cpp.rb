class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.932.tar.gz"
  sha256 "0536d3043a6df2519595f71d53f4f6a716d208cbcb9459deabf0f3d9e3e63682"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fd72487028ed311bed93bf35cdf44ba1510f0828e67749264548dd2350f38d17"
    sha256 cellar: :any, arm64_tahoe:       "79586fb0e69eb385c4f8493f95ac0003ab8db1e3809bf0ef128fe011895b19e4"
    sha256 cellar: :any, arm64_sequoia:     "bcba59888b8de8e3b54b18397b8bb05a73ef61f57b19feff01d16a22290b0730"
    sha256 cellar: :any, arm64_linux:       "454a4847b6bc70da2015fe13cb66f084b974d05b070a2efa6cde5fcb21f02c42"
    sha256 cellar: :any, x86_64_linux:      "fa7edd6b2c0446e46af7f383f71083e1e011d60f16037f756ec2beaa894c5686"
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
