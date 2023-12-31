class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.225",
      revision: "08603b2b0d8b365c4378057ce97199a8032cef98"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91dd3eced954153477930904f8dac77859caa04503654ef392154cce4e12b42d"
    sha256 cellar: :any,                 arm64_ventura:  "41d6ec779393c6e4ffbffd5db802e18e50dad8b0da5df6c423bd2de6435a7001"
    sha256 cellar: :any,                 arm64_monterey: "e2e34cde709b4a2948c873c162af078237bd1293647d42b57df9320e83bf7cb1"
    sha256 cellar: :any,                 sonoma:         "a9e210aafa909e2e1ec95be16b66d926a719abc264ed11c9e24556c851e3ea50"
    sha256 cellar: :any,                 ventura:        "37fc47309d72eeaa13d4ffd641684bc7bb233266197e045070f213f383de502c"
    sha256 cellar: :any,                 monterey:       "417c531e4e657ce61aa01905c929b4d794836c09b12cdd4b369f386e31fca861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e28a9e0491035309f911ce1fff9bc910b1caa2753c67e696f0f809a585a9f33b"
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
