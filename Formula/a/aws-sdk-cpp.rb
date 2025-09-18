class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.645.tar.gz"
  sha256 "858ed8302b2d2af833a210bccd08c822f4dd2dbc4c10e1a32c4741e73727ef06"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "957d0ae7865febda252ba93fc5e092266efb4ec4993a080ce283c324cd983865"
    sha256                               arm64_sequoia: "82101f61af2d2cf2ee773cbd0ac710d5a23ff41a0fbec1edfe0379929c76c8ce"
    sha256                               arm64_sonoma:  "c955fe6a63fe34454f783fe40dcbccd8fbdca5e3a6b8ea406b84a605cd45153e"
    sha256                               arm64_ventura: "42f47cabcad793a718a2d09f7424d652eea8a798028135d62bd155ad4a9aa485"
    sha256 cellar: :any,                 sonoma:        "360f6fe55f1f4a332ac127f09cc4d55ecda76832921d0324a17bb6411176db3a"
    sha256 cellar: :any,                 ventura:       "cb3ed539a66f4d259380a261d38f275b06f5892b91f018c7a2fc5af8d6f7b87d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a23f291892692898d1acdf2b8d2c9bd0c57641bdfdeb9c06bfbae5fc2c89b2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c9076f9f42277a973682db8e4e04c3de9875f5ddeb0302048872d1ad088317f"
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
  uses_from_macos "zlib"

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
