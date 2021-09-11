class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.90",
      revision: "ef6dc83f5db88f88f3fb838f466e5425d75d2b10"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "786da4a6df9d6738399cd8602f51bab53899351b0080d5c60f5e1a39c7c3734a"
    sha256 cellar: :any, big_sur:       "404b33c546697fc8fe5d96c4a6ed1ff4a08898ce5277007441d9d71c8eb8049a"
    sha256 cellar: :any, catalina:      "f63ec064e1458e7f58f1f153386a6d652dc7241c726b81e3635067ec5ac2d193"
    sha256 cellar: :any, mojave:        "f3a2b1c301804efb06cc8a0a58aed4c093f66dfbf38738751351a28d6d9cd268"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
