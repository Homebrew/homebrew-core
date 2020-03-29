class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.290.tar.gz"
  sha256 "86955b5de2dcabc630f9279fe71ad4f21dae60e62f5d85c25b24b3b902a25e86"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "68f28574e2f774da592e32ae21741886725a8d6b2eb5cdf50e0fb962877fef06" => :catalina
    sha256 "028b04136c718fd84abe250f4f1340956b01f8c6676da600f9c35ad323e567e3" => :mojave
    sha256 "2d914b4ea5ba9e3931a4568edb4d798b11718645224f81a2315853e16072deb0" => :high_sierra
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
