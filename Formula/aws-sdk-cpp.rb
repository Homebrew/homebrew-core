class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.200.tar.gz"
  sha256 "ee116f1550a520c6474c62aeac77b8850d6ebc515e1daca02a974f0bca97346b"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "623c12a764ffdbd9ac3fa100cf86506edd69249d822d22ff46ff1c3ab4750c24" => :catalina
    sha256 "c0bc61da1f9a716e8260434d21258d08efdfd6149c9beee6005561b297f8ae62" => :mojave
    sha256 "2ba0261a66af26163c59b89acf7360c345a9284dd45d9ba7f5ef9257d6962cb0" => :high_sierra
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
