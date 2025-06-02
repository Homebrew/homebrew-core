class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.570.tar.gz"
  sha256 "d9f47c914d8cf21ce9c4447e1c14e98d7db51f61ba6d37382bb730eca989313c"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_sequoia: "91aa2a095753824a745a75c042d483391775e69e19065cd11d30411e9bc9062f"
    sha256                               arm64_sonoma:  "9b666a3ac627142fcef34e248a34a15abd4a7360337e9c987d87ad1117c0da9d"
    sha256                               arm64_ventura: "3c49fc9735e0346b1ec069dbc652eb74e45fb75030dcbaf637e4ff360626e09a"
    sha256 cellar: :any,                 sonoma:        "1cb29cadf72a4f7054f5046a4d3ec63353570eaed4949654b2284fbc07497068"
    sha256 cellar: :any,                 ventura:       "836de4f0587a6f24e0ff482c3e399b53504330c1e04a522ef1c4151ac8eca931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc34a6aeee18ecb2f760397f237bd95a15a4c3194a42fe2abc15239e26a15b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f1df7094df9a842464e3e3fda3eb24dea5f9125db8ea326841ab899d23d3ad"
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
