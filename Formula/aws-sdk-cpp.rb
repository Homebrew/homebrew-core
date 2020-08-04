class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.20.tar.gz"
  sha256 "956488dfde4a17c304a85e5d2d2c24ae89074f4e9e873a0283c19c20973f8e1d"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "3d65ba38af066c4c7de17e5e2f162d6d392cd5da439b7831a0c986fe15c7b053" => :catalina
    sha256 "7240e1b23912526aa8294bc81d367a34a00e036119f01eb605847839a1299d18" => :mojave
    sha256 "ae877af5d899e82d1327d9fdae030ece266ab6c232ef97b1210e6b4e9c518462" => :high_sierra
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
