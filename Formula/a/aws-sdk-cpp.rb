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
    manifest_sha256 "7eb54e6ad76e69a746273c5cada67aadeed070bb63a3f532d446bbcaf97a1232"
    sha256 cellar: :any, arm64_golden_gate: "4a5ec8dcbf2db3f535e77a2bd5c00c521a8df2349784c3832fc2f89478a33518"
    sha256 cellar: :any, arm64_tahoe:       "2214a238552d5b9dfc9349bd8c91c36dfd6dd4800aa5274b729925e65a583e17"
    sha256 cellar: :any, arm64_sequoia:     "a0a5aa3c18f21a0971bc0b58e300017b7f589df0806f829a2bd4b896e935f6bb"
    sha256 cellar: :any, arm64_linux:       "3727fff2a95be4f40006ca38d9076a9403bc09c2d694056487b88ec786094737"
    sha256 cellar: :any, x86_64_linux:      "6c3003478eab6018eb364bfc901bc50554e9a506a90affffc99d5cc36ce19574"
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
