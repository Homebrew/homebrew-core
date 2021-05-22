class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
    tag:      "1.9.20",
    revision: "8c6106d595f0fc09a8bfcc6d217ded5684bf03a4"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a9742395360574e787011e6b3a2597933b12ad25d220463b4011a7d360b9d447"
    sha256 cellar: :any, big_sur:       "673fe7cbdd1c4b73c7e9e333c5e182dd524d83db5f0c21fd78ad78553f2f9009"
    sha256 cellar: :any, catalina:      "71ddb8219a213bc5785b5467a0d167d92c65f18cf65ae829c921196016c1ede8"
    sha256 cellar: :any, mojave:        "5924c88070bec988af4612a177aefc31ece7a11a755484bcf47e70e0bc7f2bb7"
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
