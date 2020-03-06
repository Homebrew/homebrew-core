class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.290.tar.gz"
  sha256 "86955b5de2dcabc630f9279fe71ad4f21dae60e62f5d85c25b24b3b902a25e86"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "47d876ba15aaa1967fa03a9fc90755d69d02c8e05372b67f1ec57849d83a03c8" => :catalina
    sha256 "84dddf21f0c13a900f0e1f8e7a7a85eece86f262fd37b95e9812b12407f761fb" => :mojave
    sha256 "fdb76956b87836cb7cf186f50fd05394eeebe7b1e13c2550543203a3fd126082" => :high_sierra
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
