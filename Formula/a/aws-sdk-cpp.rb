class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.155",
      revision: "25a6ffa46338c3b3c3c258c7123765e4e0be17eb"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f3d10a4d0dfe4f0e84eaa042a4f9345019b6348f246a81346e93bf7cd5e15fc5"
    sha256 cellar: :any,                 arm64_monterey: "783c15f5779c44ffd82af9795a67c7f20e453f23168ab250e31a0d4e9ec2a7b2"
    sha256 cellar: :any,                 arm64_big_sur:  "23f642dadcd997a496da1a16685626bc8a527d04eec2a9f8ab7e45527adb4a09"
    sha256 cellar: :any,                 ventura:        "434a682fd5d08d2b2ff11cd0df28c7972b8b21b63e8f0123cb0b9d7a26bb5ae7"
    sha256 cellar: :any,                 monterey:       "03974fcc71dc7e5d63c70200233b85419df9288c8c646afe53bb5b8f18acc56c"
    sha256 cellar: :any,                 big_sur:        "20c0ebdd000a39a8c1a39f00b0b3dfc0a3f032045a33770eb37d55edfeb4e4b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35cf22552d87a7a0f3d95faf6e4f7fe9e6f7dea08edfc6b3d5edaae58632f38e"
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
