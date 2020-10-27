class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.70.tar.gz"
  sha256 "0d68e44354b2e51e01cf08af56b34b75a384bd276602cfa1169aff601ed56dd0"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "c1c76b5469e00f7387fa739073fa786773962c3f84e655635e07a2d853f7a428" => :catalina
    sha256 "c779d8f0772dd28a93c8b8b0c0a69ff4313613d1afb11913a81e13a593e805df" => :mojave
    sha256 "d9481dbe47ac63a35eb571cf807c0b3c61cae1d8e34a7dca63d0ab01b30e7e4f" => :high_sierra
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
