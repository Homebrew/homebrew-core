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
    sha256 cellar: :any, arm64_big_sur: "7936363c4aca487382596547109cdb1e3c32e7e6c66f0c9a626a57594f05759c"
    sha256 cellar: :any, big_sur:       "94bb620d48a4d6b84d5764af07245c9e7c797a6bce3dd3cc7a80a674028da48e"
    sha256 cellar: :any, catalina:      "dd1a744329b1773153197c0abef16bd08901644e849e1e7a56655154139c503c"
    sha256 cellar: :any, mojave:        "3b6850bed234304a2d9ddf4aeea33d06736b3f3d893123ca32dd175da0bb9d70"
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
