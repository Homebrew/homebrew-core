class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.825.tar.gz"
  sha256 "9596089e8a362590965dd4c7ea2afdce579bb2e379d9f2f223cf123b9d287204"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256               arm64_tahoe:   "0cf621997b7ac83d745cb234e01c22bc3218062a9e387c611412abef74e6fb10"
    sha256               arm64_sequoia: "51f318cc5343f90a69c7dae93e2ede30e792fe323511d979c193e6d230860e03"
    sha256               arm64_sonoma:  "9f059113c85b48f232f411ca4b130bbb2c69cb7c6e9e5135de10c7a6a23e6d3e"
    sha256 cellar: :any, sonoma:        "61c54db2984086764f5198ac4727db6fe340e417272ec941dd51f32a612910e9"
    sha256 cellar: :any, arm64_linux:   "743cf7d50193db2bae93e995e55fec221d52b2f5b6c95e20730d1efdc5883fd5"
    sha256 cellar: :any, x86_64_linux:  "43e13678d2a0a09c6410e25e7da05f6d7b8b9ee1c800496833fc66c72955a28f"
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
