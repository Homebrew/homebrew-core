class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.938.tar.gz"
  sha256 "1dfa200a5ced5e479b345d0b3488d6b1980b42709173fe2ed51e02ef7a95e509"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "c743fabcc0fe76048902c0e769e54a14a0ed1792ebbc81794d80c3fcab252d17"
    sha256 cellar: :any, arm64_golden_gate: "58e84f69ed3a3e0a8663b35cdd349b4653712d0ee0d016428398a2b903623e12"
    sha256 cellar: :any, arm64_tahoe:       "7f15a163ff066072329ef80f17a7933e17c65857382df09bc4284ccc6661ad1e"
    sha256 cellar: :any, arm64_sequoia:     "7bc7d83aba7fb342c4860f09dd17fe7055da63f52940979165b2718c2ed5511b"
    sha256 cellar: :any, arm64_linux:       "1e439a0bf3d31ee092a98064bb9e2ec5dd8d41fc44767cb9c254f83321ed3dc2"
    sha256 cellar: :any, x86_64_linux:      "123d895e10d53c0f36d8843a6cbe3f37706e5986caa7aab518f6333923c0fa10"
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
