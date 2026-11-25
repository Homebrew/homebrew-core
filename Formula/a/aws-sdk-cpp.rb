class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.937.tar.gz"
  sha256 "312563291fa0b575aaadb3f6f9555c70babddeabf7373b17053a1ff9cf948634"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "416d5d8dce9c7116574c245351255d93bbe7bd25884146777080a5552d220823"
    sha256 cellar: :any, arm64_golden_gate: "a25c9ac03d93170270606153b298d5015d28558a9b66af5b3b1376df0597823c"
    sha256 cellar: :any, arm64_tahoe:       "161d9d7b06ee889ea48b0f28b52c59850ae8974736d890cefc482376f9d82b48"
    sha256 cellar: :any, arm64_sequoia:     "ec782f7daf4b37cdfd6678d0c1de85ca721b0e5caa2c1c6905e1999bb2a95c69"
    sha256 cellar: :any, arm64_linux:       "7fb4d2f1c7d09c2a8a9844f36be3e7543772db3c3e797d2c48d632372c162da4"
    sha256 cellar: :any, x86_64_linux:      "370ae21fe7d874945c0ec5d43bdbe1ea3501458992ed84ad97e1be9d297b4bd1"
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
