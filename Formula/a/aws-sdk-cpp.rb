class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.600.tar.gz"
  sha256 "bae5745e8d65551001fb9703cf8a8fe8b7bdffd6c552492f6f088b2eead21bad"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_sequoia: "b2725225c0fa55a971729f195782b425c3d005b772b962034324323db48e50ce"
    sha256                               arm64_sonoma:  "13969582853439b238da643c2c43ba3cc2495fa5fa6692d9aad604282e2b3231"
    sha256                               arm64_ventura: "9f156de3e369f50ebd482b41db08925353a9b89a0baabf6e6eda1baf2bd8bcc8"
    sha256 cellar: :any,                 sonoma:        "f9b430c81c7604d5e0be942865d7b48323f51fd239c120f429f8ce979af79976"
    sha256 cellar: :any,                 ventura:       "edd965db94db9d701a1487b750a93bb7c6758aee811240ac3466df1ff73664c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7bac82be6da72c44248a235a007e3ab1b239313bc7c74a81e5b659f3c008feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba3dc934b9cf7940489cf8d621ae625efab3d5f76b0df6aea45662b50ac89d6c"
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
