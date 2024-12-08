class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.450.tar.gz"
  sha256 "e4944268b8e23aac09597a51760e7a9f7296d52634d53425195312a73e0d5b1f"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "692c0415ce1f4b6042e7eda6df561e84bb0846c16d6f327bd4dda24a9bdc132d"
    sha256 cellar: :any,                 arm64_sonoma:  "412470660fb2aded240a852204d85f3f89f1f222a1af50bb997fef8903b09575"
    sha256 cellar: :any,                 arm64_ventura: "d5ae47fbadcd6c5ee1dd051aad05a6768ecbc2639b1c8e920308f304129ce169"
    sha256 cellar: :any,                 sonoma:        "a517b0c2c3c48f5dd1258f96d822d969cc264eff4f77011a83becdd5bde0f00d"
    sha256 cellar: :any,                 ventura:       "b37f8655d3d60b0798c85bef74198ac295b8e6cb983f5b43e14014b7f47987bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f568507b2fe726173cc2b87e84d535da4ac2b7d9678f99d1815295027b481e"
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
