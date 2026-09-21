class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.885.tar.gz"
  sha256 "b9fb6d2accb9b27bbe62b168556a8666f3e49deedbfa2d924601b77ecc70b563"
  license "Apache-2.0"
  revision 1
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5a5bc2a41e8075d06266ddf7469782969280fc2c00aac0d6b448652f9daf84ce"
    sha256 cellar: :any, arm64_tahoe:       "07a55cca37a75589a821f7df78f63f470fb3eff51522fc68bf9550b15f7519e2"
    sha256 cellar: :any, arm64_sequoia:     "ae8fed809c1ea8ed6de3181ef9e40c281c9c0a04aa35a254eb553596f81df21b"
    sha256 cellar: :any, arm64_linux:       "b1110fce28bfe40b03aac44b9eae677363fe53d8025770a6f32204044af9f4af"
    sha256 cellar: :any, x86_64_linux:      "ea02be83a6e8459cb24f47f025edb74cfa8579c577d9a7796634e663d0d3b458"
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
