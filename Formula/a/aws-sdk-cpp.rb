class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.495.tar.gz"
  sha256 "5f743acefc1899d2efaec4c98bd3279e802307801a8af8eea9ab977bd803407a"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5cc3b613df366659a71089f956bd9d5160471ebff2df04c63604c38a5a79a9b"
    sha256 cellar: :any,                 arm64_sonoma:  "1a8f3848861675660035e20d16296448cc8a9dcdb22d09d8718ad3ed76fac2c4"
    sha256 cellar: :any,                 arm64_ventura: "f217add560cf299cfb5cb3b39120f7cf3b1fbf495db49cc44b20e481009325d1"
    sha256 cellar: :any,                 sonoma:        "1ede07bd01e9ace7b930270fcd804965aff513408f6c2af9c20b6cb2706ba7b7"
    sha256 cellar: :any,                 ventura:       "cdc9dd3e994111dbbbcd18a840a6cb24f3d76945b5affddef49e0bb443ec8ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0059b0620f735cc46b145ec50eef2707b8352418b699ce3b90f370ca8d5b3952"
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
