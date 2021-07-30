class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
    tag:      "1.9.70",
    revision: "73842700df087083c1d044838b9b46651b60dcae"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7760c8ee9032131edfb17a6b9e98a0253a361959ec4f00d74d3b91d7a5bc2b6e"
    sha256 cellar: :any, big_sur:       "5226fe6a20690466a839e91317e46d559619d53f6603afcc842b3decd2737fcc"
    sha256 cellar: :any, catalina:      "39732a5cb5a02e4bdd49bb25c000a831478ecac06e6a064287f74327592c330e"
    sha256 cellar: :any, mojave:        "312c7bc5f3589c127e19db2757926f10b8cb4e206ffd0f3907ddd515eba7cb68"
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
