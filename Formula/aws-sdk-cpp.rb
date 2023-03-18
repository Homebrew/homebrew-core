class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.40",
      revision: "0515aec8e29a9300ec6ce3ae748f1dd922b7cec8"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8e0145e079f8265172cc19004b5cc43633acae3a2a5c352c94f576a17206416"
    sha256 cellar: :any,                 arm64_monterey: "9603062c7f166ba2e46a7bdec8aafec0b54a2f40750c5d57ee303592d2f7d7de"
    sha256 cellar: :any,                 arm64_big_sur:  "7273eb19f7ac3a20a4eca5152d5bef3882a62b16beaa01046fe5769819aea9b1"
    sha256 cellar: :any,                 ventura:        "7dd99a95117b79b1f62522579343a0cbdf83abcbb6e7e5ce6e9b2a7a207f0016"
    sha256 cellar: :any,                 monterey:       "6a2e1a33df7b91a081db6655ce4a24e7e1eb9a086c7f66e7d5584782309536a4"
    sha256 cellar: :any,                 big_sur:        "356befc16621c73556344491ba4de283839d1d2f70e845e5d8fffce0d930ffe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5640232baa846ddd308dc567029451ab8cd81ae1350aea2b7b9e6847cb91e9db"
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
