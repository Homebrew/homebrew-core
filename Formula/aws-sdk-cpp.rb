class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.135",
      revision: "b449fada8fa4a45158a9fea802a49b072bd124e4"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ee72049810eb47c14ba1815a172c176aa43930c093b3eab703eeda9c233f8711"
    sha256 cellar: :any,                 arm64_monterey: "3b4938c578afd6ccb6406a68fe063dd7be83e5a4bde62a4a1857cd414f63a842"
    sha256 cellar: :any,                 arm64_big_sur:  "d17b85586d6bebbd2d2b32a199b62eddc20d696e5e6ae1e3865914971b7546ac"
    sha256 cellar: :any,                 ventura:        "9e8e62082552a928039123290fd37e02c92b85e7fded1e69aea95259ba4218ee"
    sha256 cellar: :any,                 monterey:       "0052c9c37e79805dd1320ce780f027df37fbcdb798218b5058bba7764075f14a"
    sha256 cellar: :any,                 big_sur:        "2fd6ccee90e8587fff4cd23bb0c1ca8c1df16d2eb96d31a15bca248f869cf27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97cd821fe8f3fd3994f166992ec1e4691889cdeff95f1d816c2756d63ad45f07"
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
