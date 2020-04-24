class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.320.tar.gz"
  sha256 "49b61175bb532e494fdc90bdc8f2564027a1d62b31cbbb988e793cdc2de39507"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "4ea6016ddc08bf0da986e2acf65323f3397208fc67889277c4d35e8a9c1a5b06" => :catalina
    sha256 "f6e4749ac640e762093209a0774039ff7343d000c3392fefb73283e9378a0905" => :mojave
    sha256 "d1834e692c5f781af713106cdf928aef76d685d30eb832a6e3e1c5310889dbd1" => :high_sierra
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
