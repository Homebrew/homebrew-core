class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.160.tar.gz"
  sha256 "42093dd53f7465cf1b4f7507e748b00e41d1ce8ae110fdcca32c18df4a14bea1"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "069dc0d89c49652cc3864499f4ec27242ec7c4f13efe9d07f20fbe25093653fd" => :mojave
    sha256 "619ad1db82a27b6b3c6e9b23e81bb3fb68aa3956449d1e4351599a9c2a284c09" => :high_sierra
    sha256 "baecb30f252ad315ac9c67eb5ecc6bc9b5985086f1be34f1676d65795f2e9984" => :sierra
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
