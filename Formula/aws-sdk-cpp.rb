class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.150.tar.gz"
  sha256 "d51fa0e20ba851792d219a2482355a2f2e924fda241f2db1d37c4ea4a93a419b"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "5f5393b3368e5da5b28fc2fdee676cfc9cefb6e25cd3e3bf2d26c6a5b21ed727" => :mojave
    sha256 "5f3d83f9e8abb0ae64a04eb9a6ccff9329507c8341ba953dd803bfa8170d4e8d" => :high_sierra
    sha256 "676d11468b447fe501aa2d164ac4c8c8d6e5922edc769308f4c37ae79a7efba5" => :sierra
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
