class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.340.tar.gz"
  sha256 "2e82517045efb55409cff1408c12829d9e8aea22c1e2888529cb769b7473b0bf"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "0bccf3dd10a46000eac270f2bc844be37203f0eb34e5478e7c87020417523c84" => :catalina
    sha256 "3dc06f45d138d4a2eca6ab20eb2f23b4b91fbe6904f1688bec28b739da4e38b4" => :mojave
    sha256 "549e21118042e2d70bab5c3373c78a180a1ccc337432022beb71450470b55dc7" => :high_sierra
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
