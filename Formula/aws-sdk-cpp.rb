class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.10",
      revision: "f290bf9013e375f90a4826c0f5ea5de4daba10c6"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "deaa5326af5fce40eaaa72280fdc5b96507c91fee41f72ffb8a50af7ff6f7b92"
    sha256 cellar: :any,                 arm64_monterey: "b1a6c59b6300f1a14d3f917006ae6ea5efbcbc3dafbc6a27112348bc7a29afdd"
    sha256 cellar: :any,                 arm64_big_sur:  "156b145b09f14339bad1ce8ec345873c339f5249e2b2c36ec729094963ec8c12"
    sha256 cellar: :any,                 ventura:        "c4d3a9b38885c951b78183f12ca2468e59e099aa0d6bfe7c68bd09d955679c39"
    sha256 cellar: :any,                 monterey:       "b4b7046cd8a911772511f9c9ca9e1735bc5b4e373d66dd154073bf74208ceee5"
    sha256 cellar: :any,                 big_sur:        "730efc08f91581736df053791301484a6c4a7315e2b729067da4dd65d6f2e50b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4c9dccc73fcfe99f7fca0cde41ff1e1ca15a37104ba155a188633e8093139be"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    # Work around build failure with curl >= 7.87.0.
    # TODO: Remove when upstream PR is merged and in release
    # PR ref: https://github.com/aws/aws-sdk-cpp/pull/2265
    ENV.append_to_cflags "-Wno-deprecated-declarations" unless OS.mac?

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
