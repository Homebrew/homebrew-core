class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.250.tar.gz"
  sha256 "5aa14947c45f66a63eca0a5667117f23d0b5cf4ddb1b82c63d51e692e833cb4d"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "c85840e349d21d415e8008b3974a150617acd01f501d69e57b07890a6cbfbbfa" => :catalina
    sha256 "e10b2ba552debdf5c45ea0d7d5032b83b3d79cecad231c59caeb40735b188846" => :mojave
    sha256 "6b00ecdf0e94cfe05d9b941ed5105d59e7f4435ab1712c0644d7f9c53a6b8eb3" => :high_sierra
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
