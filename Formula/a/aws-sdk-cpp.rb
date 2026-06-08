class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.810.tar.gz"
  sha256 "73164b355d19bb15ff64b9bce8ee1ae5dbdd444534e900aaf869c1e08dbe03b1"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "4492028b8e1d71b520b0e945c50918b8324a823feeddb40d11db21eb1e41a6fa"
    sha256                               arm64_sequoia: "a39aafda735345b66c3fe002a70cb285ee9e18493a2bba17f85edd475779617b"
    sha256                               arm64_sonoma:  "b4c177011ccc3a793d579e16b52f62a6909652decdfb32e3a9fc92d97514fb7f"
    sha256 cellar: :any,                 sonoma:        "0052ff8e8c3cadfa866c1d3fd171498a3f24f4446f6de5fb01e56e13c849927b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5357d74ca5c5f8a2784e6c4e4b5d8334985a646ed85b044ca52a5004b2a23146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a732e1330a1c8589bf3a786f1512723347434aa526c7cbdca9d69c944eb1723"
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
