class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.720.tar.gz"
  sha256 "6b0f56e8f6f7d5a837e73173646630161c2b7419ed178afc3f5fd5b7bab25e11"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "c1464a35d01570d2a72f37c426fe1500d8b7e1d6c55dba4cae40387fcc65b0f7"
    sha256                               arm64_sequoia: "3a9bee1d12a201f4593b2d6bd25be9e6d5c74062f63eb661aa7ffbf65c67c43f"
    sha256                               arm64_sonoma:  "b4387f61dba330666f7f7f80118f16c344b0de6d4d74cd318b7597c11475ff22"
    sha256 cellar: :any,                 sonoma:        "069d1e23cca439e822572c52caa7cbae8604c6ea49825095c1eab451b41be0e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b0c2ea0f61bd45dafa6a3fbc0b3cf40efec7675efe2ea2729d9d2dc238af462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b91fe6ab9bd011b62af774f240f520c2fb6a44352e9ffe1abc6522732ae7350d"
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
