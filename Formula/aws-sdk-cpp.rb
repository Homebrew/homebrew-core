class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.230.tar.gz"
  sha256 "7cf77c3dd830590a877c0155107e607cc8dbe4083e8b909254636f439f8c627a"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "fc2131ef665c09f2b26ccede0f86b379b46a359c8886f070be28c4cb2e53b47b" => :catalina
    sha256 "beff941d5aa881944550a8221ab9efad1d642ea63116baaa3582b875edc263c8" => :mojave
    sha256 "d137b2274b648a5d5983cab49d8fc587e15f28f23d35fcb3a63658fdf6869444" => :high_sierra
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
