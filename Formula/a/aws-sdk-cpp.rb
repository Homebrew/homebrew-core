class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.936.tar.gz"
  sha256 "167df8506111dc6e7dbdfe638c72559268ffbaf2628f546ed42bf23b991b44fa"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "8d0d116824dc77fe8e70ad2dc02eb798c976c89ebadf47b5baf57dd15901b835"
    sha256 cellar: :any, arm64_golden_gate: "7586392ef619d28d1e86d732e7db6cdcc0b3557ef41ed5a0f622bf9cccb5d63a"
    sha256 cellar: :any, arm64_tahoe:       "aff79c36e25b7f34f05971d8feb45a996e66b283db2d5fe5ff31369279131183"
    sha256 cellar: :any, arm64_sequoia:     "2d659c9600a96b4e2127559db07a35cc9425cb1a25bedac82112a34111ca4343"
    sha256 cellar: :any, arm64_linux:       "e15ead6d71a9ac1c9e80c32df7dcd4f6d54fb625a8b191df5d213d015b8eadc0"
    sha256 cellar: :any, x86_64_linux:      "2a0e3481400892a31092e9124932b99cebff07508e7ddfc7024acefb5a94df70"
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
