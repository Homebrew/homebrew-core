class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.915.tar.gz"
  sha256 "14aae4edf6c1b389c2e43ed077889e767dd768495846a3f506c240a1e478f460"
  license "Apache-2.0"
  revision 2
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2bc2ffc775e6dcccd4f81da44d4ca98664ee210cf6b33e167765b0c57d1dfe02"
    sha256 cellar: :any, arm64_tahoe:       "ff9a2a8ed44559a59ac15d41bfe8ed3a3b2ecf41da29801b3acd35aaf4998965"
    sha256 cellar: :any, arm64_sequoia:     "31a394542719c86e8d04c342bc1a02c0a3563cfb67e89baea25740197659754a"
    sha256 cellar: :any, arm64_linux:       "91950690f0b3ef0d5e3888a3c73150f9464f654f332d82528c177b963393ee18"
    sha256 cellar: :any, x86_64_linux:      "2e3bf247ad65ce645ca6961ccbc1dae5bcd877477d8bd68f0d937b81ebb1b70b"
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

  deny_network_access!

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
