class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.929.tar.gz"
  sha256 "8963f5c5b52c5a9bde6e0320d766f72cf65d7e04434a24dc9a34c593501b05c8"
  license "Apache-2.0"
  revision 2
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2aba207152bd0b59dc435e8213b315e0e36f58f2b330c07e37b940cf9444d8c7"
    sha256 cellar: :any, arm64_tahoe:       "7dffe9846178f8a83a1ca5c6aee173940c6bb9bb22aeb94d157a43dc1237f1dc"
    sha256 cellar: :any, arm64_sequoia:     "1284c5d39d15c925a249f3bcba73b6e65a2bf47c337ec755f35a3b34f636ab12"
    sha256 cellar: :any, arm64_linux:       "ef6b6f21423c62a6dd08a3656e9c8cbd431de865b768c66b79ceba8a3cd9d8bd"
    sha256 cellar: :any, x86_64_linux:      "7595c4eff7ddab29d9f8e52160a0cb1e60f99054ca2d8270cbe89d942d6da81b"
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
