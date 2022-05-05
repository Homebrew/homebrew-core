class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.250",
      revision: "3b4b42f5b9baffae183bbcdd8ac59285a4a0f847"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "973877fcbaa683beff4b5adb011a4344d1c6678423dc054da1ebaefde1c57b83"
    sha256 cellar: :any,                 arm64_big_sur:  "045fd445287e7dfe178900bdedfe7841df557d9da51d2ad55779052bd5d12554"
    sha256 cellar: :any,                 monterey:       "cf453175ebfc536d496592d935b53c7bab5d51c5210a3ee9fbc96397bf66d004"
    sha256 cellar: :any,                 big_sur:        "cd67532294a82c9139ec3c61a4526552438531c1c851a665d427ad277112af92"
    sha256 cellar: :any,                 catalina:       "121bd4c8a808be058e32efafd950fe538e8f54a6503c76a12b98f68c8a340b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d9f8a151885861f24fdfd57d0474dd20f0bbb303719b5c0c9b2189c99c90b21"
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
