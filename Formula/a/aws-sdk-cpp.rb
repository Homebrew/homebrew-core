class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.855.tar.gz"
  sha256 "d9cd0437601f56139bbd147461d22ffa9af5669259655b6a25502b2c782510cd"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256               arm64_tahoe:   "4c6d3ecea5f73324086158fe2d9e6e092a30ff263bdd8e3ec3a4a07ab21b7985"
    sha256               arm64_sequoia: "c3d778fd276dfb9c99099c88fe45a2bc9d0dc59956d149c88f4489c5a2e61d37"
    sha256               arm64_sonoma:  "dbcaa2106dfc54a086e916f875c932a326331951e5f2ce0525943ba63ea21fe9"
    sha256 cellar: :any, sonoma:        "712e064b648adbc0cf77443f5b5aefd3e24f8743db45ddc086c666fa960e5f19"
    sha256 cellar: :any, arm64_linux:   "c1b78159c4e7d802e0eb53abe51d6ca663519211a11d6a99878835a5b17bfcd3"
    sha256 cellar: :any, x86_64_linux:  "d8b905674ecc6f8770d067f71f5bc117ca91ea6a1d578ebbeecbcf0fdbc4cfaa"
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
