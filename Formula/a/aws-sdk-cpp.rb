class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.928.tar.gz"
  sha256 "c2a6ef80a6d7c7b88dbcb5fb14aa47430dd661773667f18f947aad062fb287d2"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5877835e9fd45f4552ac833a4d95893f8a80f40d7e6f6a6fcb0fc99ff32fe941"
    sha256 cellar: :any, arm64_tahoe:       "663e2fcd41ffb3b524cd7085e508f7d3f5e6b2f8ec79794725b0300fde00594b"
    sha256 cellar: :any, arm64_sequoia:     "5c31b6012c65ab27da7f245078723377917ebe448427d732aa7fc59eb7bbf6ec"
    sha256 cellar: :any, arm64_linux:       "cc36fd3bb76d73dab6d9749275645a7403eb36cc65860cd4fb488e904830ef5e"
    sha256 cellar: :any, x86_64_linux:      "0d08755e6f23e803a63a02f9b0fe97bb9431d74af57a9760fef9ec3d0e64b139"
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
