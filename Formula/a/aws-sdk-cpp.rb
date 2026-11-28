class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.939.tar.gz"
  sha256 "2fa48fe08f7d6965b662518bae13734a2acaf032356296ed406cc14ac89f2011"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "1e4cc5c7f368dbd4f08c925ce8d416dccf3e633d93fb61094586985b2ff5cad9"
    sha256 cellar: :any, arm64_golden_gate: "d382c51df1131d52fab9dfa865587d57477c20b2dd45584035473d1dabb0af30"
    sha256 cellar: :any, arm64_tahoe:       "44030e09e181a85c61a2b0155d191749468c9955d98648722cb5da2d52f2848d"
    sha256 cellar: :any, arm64_sequoia:     "354e2bcdbd1cde5e155313e3efa37cd61edb867e23995bde91049cc5853137a7"
    sha256 cellar: :any, arm64_linux:       "d11b94e7973521b5fcf9bf4c5c9188b9c32bbbea37ca41d14d46c3320ef1b2cc"
    sha256 cellar: :any, x86_64_linux:      "b418de48f52f8b7f3677d2f4937b69ff11090f1809edb15b5f26d52a7a32e5f3"
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
