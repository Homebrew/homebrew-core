class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.330",
      revision: "00141d248cabcac0995123baddc88f98f4f3c113"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "408bbd872b788eed0eaf9220e5e4811ad2416578139813cea81ad28227ab69b5"
    sha256 cellar: :any,                 arm64_ventura:  "bc669b676196a7d237fcbbaced0d15844d44e3af23533a228ddbf954355b473a"
    sha256 cellar: :any,                 arm64_monterey: "82c4dd2b0cff468f95c121111305dd5430155fad704c50fe453c556cd1b60f1e"
    sha256 cellar: :any,                 sonoma:         "dd2e240599fb1ffb00a5509eb4e05b70a92e7530dd8ca0f316403b7554320c44"
    sha256 cellar: :any,                 ventura:        "ab4de8da049cca17a3b7b0f48494b4c9fa1e76aa61ce950a55f838fd7ef0e01d"
    sha256 cellar: :any,                 monterey:       "b25d640becf27218bdafe9e8927a12840ea7139c44b5fc6621886f532fffbb27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3019a54917401dc24acf62e7e397a19269dab42505b221cf520da23c06b96fb4"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "s2n", because: "both install s2n/unstable/crl.h"

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
