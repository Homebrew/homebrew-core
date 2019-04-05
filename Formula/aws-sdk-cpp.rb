class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.80.tar.gz"
  sha256 "9f7576892155d577663f4b0066521e15ef88e30760a79877ec4d4040cc120cba"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "780d5543770d4f76aeb551374c081db27cdbf0ae2b0bb3b47bc8750e4ea0e9c9" => :mojave
    sha256 "ddfa11ac86bb8ef839714017f7bf77d4ae749766355f92974a22634cdad5f855" => :high_sierra
    sha256 "adf7340b073669482049fabbfe2ff10f35147660f01aa04579761df650792958" => :sierra
  end

  depends_on "cmake" => :build

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
