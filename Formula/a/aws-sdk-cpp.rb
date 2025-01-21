class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.480.tar.gz"
  sha256 "7d6a2e4ba851d773236745ac399a5120bcb04e8122e45b589742bd45ebc72a7f"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "71b15e826f962515dd14adeb876ab95d633ccd4d284bb15aac2094a061f5e4eb"
    sha256 cellar: :any,                 arm64_sonoma:  "0db2abbe798907acb6cc5846c1d8346646a08b7d635d93f49ba37dded71abe6c"
    sha256 cellar: :any,                 arm64_ventura: "c1c83718cbf49352b98dd04e3fe68bcd05e353d649ece3c564b0a5a6120725c5"
    sha256 cellar: :any,                 sonoma:        "37df18081f54c2079e6a40dadc84c45f9941e34c1a86d5e6f25b2216a61f2100"
    sha256 cellar: :any,                 ventura:       "1102038dc9539dce0a076ef0f7b6f69752898605645ffacad7e5cf3137a986e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96226da9e716bb42689c1baa5406636b9353574276a718f86036d13b46b1793f"
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
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
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
