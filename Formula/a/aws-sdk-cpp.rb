class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.765.tar.gz"
  sha256 "0a61a9f83f2b621b4841c054c1dbb82829daa471190c1ab696676ede625f81a7"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "aec87511eca6398a24a183a3840ab807eff700f125c9de86173e1184109cac6b"
    sha256                               arm64_sequoia: "dc822f9aaee107d43d20e0cdad96efad6320d04d530717edd1073fb23a28259d"
    sha256                               arm64_sonoma:  "1ee07025d28bb97b113346e43798b1b9d6cc912832416315f1edca060db51265"
    sha256 cellar: :any,                 sonoma:        "ae328fedfa43a66d38ec2ddc81c413af08bfa1472dd715b89f9d3e8d2cedfdfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951c3ddaa2e968e616f6dc2b2c8bb1705bce6f56e10e9e45d8570538104a5204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b79e1c7d1063caff2ab5455e9007912fcd3884e79ba1229e25f1dfd9fa6790"
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

  def install
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    linker_flags = ["-Wl,-rpath,#{rpath}"]
    # Avoid overlinking to aws-c-* indirect dependencies
    linker_flags << "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %W[
      -DBUILD_DEPS=OFF
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake/aws-c-common/modules
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
