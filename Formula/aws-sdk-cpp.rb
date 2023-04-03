class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.30",
      revision: "1729b68bfcbfdd28ec5de3a94d5792ec4a54d01d"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c90b2b727888593142539afa6a1ebe49d55ec8ab740357435910163f45385d6"
    sha256 cellar: :any,                 arm64_monterey: "a274cdfe57e4c8a517f7af61d227b31544c866f26e0ed34a69bd8fd27f13c9e1"
    sha256 cellar: :any,                 arm64_big_sur:  "eec87bb9e15b78fadd126e5ce4a622212d6290b64fd8ff6f759fda78ef1998bd"
    sha256 cellar: :any,                 ventura:        "1c2b5279807ab9794772d9de8e93ab06ffc20771b0befbe75e6190a4bc6950c0"
    sha256 cellar: :any,                 monterey:       "990a648ce533cc3ff67aa17d8c72b66bf13f6f01ac15bbaf2990c4bd16dcd5ac"
    sha256 cellar: :any,                 big_sur:        "1c96726e599f29bfc760f0fdfc45e29330fd4d174b99984440ff2c80256aeb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3953446d48d90501521edd51f060c764ba998be3599a30ce8d2934d27205c3e2"
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
