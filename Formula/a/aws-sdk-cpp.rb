class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.315",
      revision: "a9fcd936ac12dde47aae4f7fef5442ebdbbd450e"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "323069a3197c3fd3f523a12cf777e64d3891f9191b652d2496b3691d3a49495a"
    sha256 cellar: :any,                 arm64_ventura:  "795865a49e619bbe4aae75d45220545a310e1c2bcde650dffe89bbb7bedcc561"
    sha256 cellar: :any,                 arm64_monterey: "416d271a72bc1aeb1e9e0792c96bea8f0df25c61deb6b9512f9cbc7e85c00822"
    sha256 cellar: :any,                 sonoma:         "7e1f50ab624f60caa39c8265c03d8140025821448bbf0a8b2121f0f07cb34c7a"
    sha256 cellar: :any,                 ventura:        "efde420cb2e0e3a31d5d3cde4451f432d1b33de7f09e7982286620fe0f3ab613"
    sha256 cellar: :any,                 monterey:       "2d0f66a5361083978bdd4476078d091a889fa908fa092121a8205995f7a39deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24748ae8d8b41a7c9cc8de6609b54e2f702efc5c65cef99c4a3bae62560a2ad8"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

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
