class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
    tag:      "1.9.30",
    revision: "177dd5e612c3c5230e84628506a1a98fcb517591"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "68cdc667bd56197599bda997c0fe0eb197eed94cbb8d8d0175237081f9a4b1f5"
    sha256 cellar: :any, big_sur:       "b746542c3888bd4641af555d899b45f15535c2281bfd8dbc1d1bc8e2942aa513"
    sha256 cellar: :any, catalina:      "d99d504a202a52fc3d7c301477cbd48fa66518c64d7a6d713aae854382db7bac"
    sha256 cellar: :any, mojave:        "fa5e19506949fbbb033c661611f82fcf2bf87e4b2fef0a6fd9f503288a1aeb68"
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
