class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.240.tar.gz"
  sha256 "3bbc39cc8c8c53bf487c858e5e6dbe4db342904abc7dbfd9d8c8f7d09e6e9ae5"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "cb73463283304d9e4ea89800bab02d1dadb418d607a4030b851c77b37c83c961" => :catalina
    sha256 "ebd00236853fc1a6968665a7a18a8ba968ab4c48f02623fcd95da005cfea2bad" => :mojave
    sha256 "15beb512e28d0552b0304bb9d7ba5d83537130f71df52d1f3ca543e4d69802b2" => :high_sierra
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
