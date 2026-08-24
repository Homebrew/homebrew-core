class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.870.tar.gz"
  sha256 "b8eeb6a79f29e6fa92a75450b27419f1e8ec97df7482703b83fb5bb59333069f"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256               arm64_tahoe:   "273fa4254b2588ad97de087a62ade2783685660ef47eb313ba422db7a6e37867"
    sha256               arm64_sequoia: "0fb4238fb3e1c35cac7e1617dd723d9e849db9bb319ba4acda0c42fae75ae3cd"
    sha256               arm64_sonoma:  "40b7df3331e4fe3784cf7dadb8a3505130ed660004c7cfea3920a26574292f2b"
    sha256 cellar: :any, sonoma:        "e241f8eabc494bd3286796b2c22a542610f02a47bd17a56c8d9e132525c8cc46"
    sha256 cellar: :any, arm64_linux:   "26fdefd5207064ca6c56e396b7991f31706b79febab530c1f361c7a24ef278a2"
    sha256 cellar: :any, x86_64_linux:  "7ff87a463aaeddfeffb907589e66290823d480845b6513d984d07ebeed983598"
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
