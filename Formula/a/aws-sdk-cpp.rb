class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.924.tar.gz"
  sha256 "74f9c31fc308a35b25323e2dc81317825e1b136ce539e48aa62f7b0acb2af0d9"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f41cb34cc6165f253ec0c07f185e0fc1666e8a71cf2d762c647281c61008f91"
    sha256 cellar: :any, arm64_tahoe:       "d8bf431f3dae4661da95505c916b051910ee17b12912ec6ed8b304d78fa31414"
    sha256 cellar: :any, arm64_sequoia:     "1b5efd923c2fbfb7e432ff366642ab89c817bb3fe72853c51ff960e0c42450b9"
    sha256 cellar: :any, arm64_linux:       "e47f9dec7eac8b2612287e49722f9a9b0e7537e4120bc68053e87b9dcadd5082"
    sha256 cellar: :any, x86_64_linux:      "a7849086a0d28e6cfaeabdb9c6ad4fc1afe12b2b1be74aedd868a9e28bbc7c11"
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
