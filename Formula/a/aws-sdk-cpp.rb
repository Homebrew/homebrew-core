class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.780.tar.gz"
  sha256 "e24d30f78843021a00293ac3689b3e5a4a5188d2f7bec602322be36e680a49e7"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "afacffff5a1212baa37e588f678afaf1db0122601e0a6ab60e4a35acd5bfef50"
    sha256                               arm64_sequoia: "9b8560ffb9b265129eb2da188f640f65d20f695c126d62caf93bc0b30d1b7a2c"
    sha256                               arm64_sonoma:  "265f087ee5bf630c2bf4919fdc8f25b148335d461d92eadb83a2d588e705eb1c"
    sha256 cellar: :any,                 sonoma:        "b4d2e548d25c8efde4ddcfc77a3c6ef9497fb4a4331c4c54c80fe30a54ff169c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9803c1ec51abd21541434014ba92bfe4f6bcc724f0bf3aadb93189acc819f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6e8ed7c8ce88ab6b1d6d2ad9a76239e01397fe8f107ce3007d6096017ee5f20"
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
