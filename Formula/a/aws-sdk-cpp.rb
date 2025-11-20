class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.690.tar.gz"
  sha256 "4b4252f73055f5818d9fa04cc04a8d26d71ae03b2e6427ae66864458a679f6f5"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "c96220e26025b8a3ab7d5d5ead109532bb26498fbfbd806e5f74fe8557ec9b64"
    sha256                               arm64_sequoia: "6f9fd6054c3fd7730c96c8960ef6808edeb80db20a25a60af49429b7e7edea78"
    sha256                               arm64_sonoma:  "e1f86fd79138a1dbd367cfa724d4bdb4ebf59564417c15f3aae6e7f050ac54bf"
    sha256 cellar: :any,                 sonoma:        "7537b1b8195fe94bd0447ae16dc063d8b90ec1adaaa1b7f3f0d7c666294ea63b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb5285eddd1da839164e79070fc3e4c5dff833ab5ecd91eb655706fe0d8cbe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492d08c452767b2f604e3f389065c82569f36ac2a57f8088c4497b7df84368c0"
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
