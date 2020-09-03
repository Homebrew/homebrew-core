class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.40.tar.gz"
  sha256 "1e95f2812d19d77ba361301a5a277b91baa4782aa797311b738c8b9fa1f5e252"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "32bf8cca3fdf2f6e79d9f9c604f314a1f987c403e738e5185ad45fe55652fa09" => :catalina
    sha256 "cd590300a327621779bd809105a9ea1af05f37ee77526865d203b9b034407e6a" => :mojave
    sha256 "e3aaf074d934ece626f2f1f6b72f0d03bc77597471273d65abef3c32e676a18a" => :high_sierra
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
