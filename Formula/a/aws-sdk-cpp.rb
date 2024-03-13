class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 15 releases on multiples of 15
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.285",
      revision: "8213a588808acf5148b0f739e0b558879955310f"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c016252c1c8140fcdc570e1faee3d180bbd82eb123bbc01e3a93d18c690e97ec"
    sha256 cellar: :any,                 arm64_ventura:  "d50515cb8b72ae55640235795be866db3be0c38c86688aa6b6889cfec8409838"
    sha256 cellar: :any,                 arm64_monterey: "d0e37b6de3dc7405c7e8e1a7e8d530fb57f953b76d69de2c02dd6b9f809dceff"
    sha256 cellar: :any,                 sonoma:         "e493d7933f8d4eafe10f2e9224b213114ceaa0fe87bc6223acb2406499cc5e17"
    sha256 cellar: :any,                 ventura:        "faf741eaf2a99d68573c01c31e681819296af68978cb1031a77c9211f3bc52df"
    sha256 cellar: :any,                 monterey:       "d0cbfb3d6ab3a4ea8b93db8422a4eca695a6b6f52bbf2b12a5971a6c5dc5a8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf25de6a2d65b52c1ade8f6fe0310f50256a17459298ba00eb9b2ec965b40ce8"
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
