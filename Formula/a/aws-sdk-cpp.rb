class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.285",
      revision: "8213a588808acf5148b0f739e0b558879955310f"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00d6ed4a1d44cf57cec6dfe90a45c731e77fbd89bc2e7e10b118a5c09091a772"
    sha256 cellar: :any,                 arm64_ventura:  "300751fb3130117e188b6eedcd416e0bfacc3279c49ec78cc5cba53d5ed13f64"
    sha256 cellar: :any,                 arm64_monterey: "15b77d6dd0416a02a6301595d2e38464501ef507016bd85cfe68d0f30e131a88"
    sha256 cellar: :any,                 sonoma:         "56e7646d49ac546468abc6502b7c8e90181219264a1e7486d25e642c97d82b19"
    sha256 cellar: :any,                 ventura:        "d1d389171862492aeef7a1dc91dea4a0607438a8dfa98b4a92ac3c844e22a269"
    sha256 cellar: :any,                 monterey:       "8f2939227d817fae7741d3cb70f8ae055d7219f535e14a67c9c03aa0e6ba85c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae7fbc1fd17179ab2b41aaa0d95f809b2918642ec51b80f89e7f57944ad9a961"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end
