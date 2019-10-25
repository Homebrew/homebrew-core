class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.210.tar.gz"
  sha256 "e5b1d8e6abcc6e85fe85357f05fa3b76b4a7ad7edb6b696b6e72221e61b9dc42"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "b2d78e18476f2972ceb1ac39c4ab4ee4474e775baa0c0d0166e7e206f0643f08" => :catalina
    sha256 "2b1792689913d97f8a98a49fa79f43276246a0baf0fdd7caaa046435bb84b8be" => :mojave
    sha256 "a12cffb0789b950add1c7ea40ed9694e19215e4069657a1aa646b6cf015444f0" => :high_sierra
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
