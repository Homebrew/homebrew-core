class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.660.tar.gz"
  sha256 "e4dfa5399f00a8bed8323a36dac66ac40bf36152e6e5137c164b8720c23edd0a"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "2cbdb2050debf7fa972ff57e9aa9f92618b50cd45e80d9c9a6bfa0279fbbeb07"
    sha256                               arm64_sequoia: "710e802fd337a347127217de3ce5b7100ec2d0aeb179995e53f930aa5128a799"
    sha256                               arm64_sonoma:  "4bfbb9a9f3ea0f177dbc6a6c2ea8244d439a1648ec2bd904019f09fddf273f41"
    sha256 cellar: :any,                 sonoma:        "3f6c3d235cfc0eac996b6d230162af3b6c82ab475c51a9756d3c8d3c040bacdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71b8413e73e5a1e23f8ce48807c8cc4bb7e0a32ca3416b0167b0dc725c43f28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90eca335264bcc371af03fa41094abbb7e0bce4e4e867802e6149aebd4ac5a17"
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
