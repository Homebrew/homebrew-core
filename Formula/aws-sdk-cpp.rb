class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.160.tar.gz"
  sha256 "42093dd53f7465cf1b4f7507e748b00e41d1ce8ae110fdcca32c18df4a14bea1"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "f0659dd250f149db5979a9ac367dbf4e6bd000187df248a75b7bed9aa4618614" => :mojave
    sha256 "047197c1a24865c30b4f1d731f772a2a6a6d71c48caaa5801a8fd7c4aa5bed57" => :high_sierra
    sha256 "45d6af0155ca136022cc4114b1c6addec6d704e2694156f750cdd155401b814a" => :sierra
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
