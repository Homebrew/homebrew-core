class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.90.tar.gz"
  sha256 "5bfe5c6835cc39b74f1423d28d18002d6ede91b4c1264e2ef7c0cef380dc0f78"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "761c1e4127dfe4aaca4cd83fcac7e2bb3d495f1939ef35194c1d43a6d0b1fef9" => :mojave
    sha256 "3a5cf0499b653609337102231061810adb2faca1ca6af5e37820ff9fcc49ddd3" => :high_sierra
    sha256 "5e776f11dfb2151ff87713a84631d5ac3e0a0485e2a4286f8737167f867484b0" => :sierra
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
