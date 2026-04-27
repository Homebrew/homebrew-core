class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.795.tar.gz"
  sha256 "dcded0fd7c2bed73502a6ba802fc2f714acae0d26abdf09cdf701a84463af60f"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "ba4b7a0a972cb6ea1ce8acbfe92dcd650ee46750278aebbe5d27dd14f0c8ab74"
    sha256                               arm64_sequoia: "1d210b882fb5a49246ba42f859a85cfd3ddef6768c681890a79d15b3ba258113"
    sha256                               arm64_sonoma:  "ec7c9ca61ac643b205bcf6b1e765b97ae3ecc172c2daf41fed3217f32b680e81"
    sha256 cellar: :any,                 sonoma:        "392967904b64c63fe3ed767a76b74b430fc72944fa53ef31da0845ac74c3e636"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "726c8c5cadad1ee474766b25f3d0e4553fbe60a4813eea2b4f2c6922713e8b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52c296e2d718fb024d99b50915bf5ad4658388ea65ba1d33fd78f6465db563ff"
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
