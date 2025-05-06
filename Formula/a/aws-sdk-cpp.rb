class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.555.tar.gz"
  sha256 "a8c1401f040e38b0bd9a526805199135cb98be7f7aef682c7545c7b55c48166a"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_sequoia: "6edaa7527cae4358640d36a7eeaee33479685d9e3814c2ef7d4f2f38ed0371d8"
    sha256                               arm64_sonoma:  "60bdc8439c1062e30e43fa90f2f6eec5f08b686e02fe8cf3d98a9be19730be37"
    sha256                               arm64_ventura: "0dead493f566a52343b631236f4b88c4aab14cac38bfce14efcc091a82d45e09"
    sha256 cellar: :any,                 sonoma:        "e6a4050542be4f2a99b3fc050a0dff6b14a4167ff060151442a2c2e483e0c466"
    sha256 cellar: :any,                 ventura:       "7fbaead8ba8dac4007116a117db5bdf31f2d737f3942a9723945dabbdf9270f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f952a01c8cc6a8fff41cd818ea92c1e654d02ffb8d85bb8421ff5d6366725018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d57d5d7460c3110097f88844518cc6401643a5eddeca4d00caa135f516c3fc3"
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
