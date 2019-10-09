class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.200.tar.gz"
  sha256 "ee116f1550a520c6474c62aeac77b8850d6ebc515e1daca02a974f0bca97346b"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "f3bc9827d265e8da81f6ddeb6a738eece37ae02e7039eb4230084b755cf8d4dd" => :catalina
    sha256 "4d5228077ad982e5c8c5fdb6f63902098f687746ad64e909c520c03792c7feac" => :mojave
    sha256 "de43687fb5a83b2d0df4e77a931ed67ac453de8481b71b8b862334ce441f584d" => :high_sierra
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
