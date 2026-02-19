class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.750.tar.gz"
  sha256 "053d1f9a166e1614bef2691d652c800e5a0546f6fdf7676047ae62fb2ee12b64"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "849dd3096032b267a151db934f3364d52f0012cc030e58528718848770476996"
    sha256                               arm64_sequoia: "dc0eb3f3284afeac68c2b1232086dc40f74341a37699ad16a9afa86871cfe5be"
    sha256                               arm64_sonoma:  "392f755022f2f2c115b5e9735e80c5f3580b4f09c3847651a4bef3a3a51007cb"
    sha256 cellar: :any,                 sonoma:        "a5a348a2b4dd2220f0a7770bc99204727db14e2f81a31c795eac4bee6e99081d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3012d980d9a14dec06a8cd8bbba281a0869b7954995d6c0e6b24e6f21986d535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd771f0434b98b50e2f4976c36e93d0bb0242e02947701360411a1485e4dca8"
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
