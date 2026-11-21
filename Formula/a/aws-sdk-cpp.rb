class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.935.tar.gz"
  sha256 "dac4a116685289fb6101c6cd4fd821ae1ea261149bfa822c133567f5e6e5dbc6"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a589cf30e345cb20eb4bf91b897266f41a4966e567e0fd407fc9e2f0c8152acc"
    sha256 cellar: :any, arm64_tahoe:       "28bc9e74275ed66c44061dab000f98d4d055b4108256d1e9569585fab516064a"
    sha256 cellar: :any, arm64_sequoia:     "7d2a68e50b7e71c3be8ff2964fd507f702103101e454dea8468d2a612308079e"
    sha256 cellar: :any, arm64_linux:       "4e830e55386cc6b75c585a34f573997470871f62188c9fc59d609fd756eebbae"
    sha256 cellar: :any, x86_64_linux:      "62246e75764fe4bba6f64dbd34b40a1197c180a6ea4bc2c1bf8c78250375835c"
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
