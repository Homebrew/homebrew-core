class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.150.tar.gz"
  sha256 "607aee5c367f0842b18175e7e6df08edbac82ed483ccb34d5eebd9e6a7a9d3e4"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 arm64_big_sur: "a673efc9960a488105b47fcaaf022c195023f5713065321938112feea755cba7"
    sha256 big_sur:       "418d45b9f7ad78f0fcff3d14ed06536a11874f920af465c6a35511a1f14c30fd"
    sha256 catalina:      "3262f61e740c0152ba86bb1a2facb4675206beb2db314131c337d2348653dca2"
    sha256 mojave:        "13fe1bb7b7a491b46b4fea8a79a34a7424c931e303713bcd72f334e3e2150d9a"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
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
