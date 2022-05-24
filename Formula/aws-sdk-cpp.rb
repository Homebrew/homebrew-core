class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.260",
      revision: "c1df81935a08232b853e2d7eae6fd8c70f99d459"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dec82a85dbb9dde9c4db6c49f40a4682a88cb4a2338c00617668701b2827f0b7"
    sha256 cellar: :any,                 arm64_big_sur:  "252c3db759aa279182d396d088a7cc497d710fac7d4d341247703f41ec2f98b5"
    sha256 cellar: :any,                 monterey:       "2e9daea5d20510df78b6cd011c31fb2e252ead8dd5c89122cb475f316514929d"
    sha256 cellar: :any,                 big_sur:        "7306b8e64ffbd6322d705b5376f20eb0e7175a3f299e9ac24b3b0093b2026f50"
    sha256 cellar: :any,                 catalina:       "e3a82157ac08f5cf3e73073377aed92fa65e52152d194406be94bf2bc7701023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5aaef4a861fa13325e3d063b3444846b2b8c10ee6a66aa7346aec0626537c84"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    mkdir "build" do
      args = %w[
        -DENABLE_TESTING=OFF
      ]
      system "cmake", "..", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end

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
