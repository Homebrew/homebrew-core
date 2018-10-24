class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.5.10.tar.gz"
  sha256 "b10d4d643cf88fd44d6ac5f36a0c473105cc8bfdc7ea1a8d9b67c29efb875885"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "df342149e5aa1e69b5c289a686c67817e0d4fabc1ab936be66ac172816edcc6a" => :mojave
    sha256 "38cb9d8a2c0881f66daca887582deaf7c7dc5b34f63576c42616cc944ab33e2d" => :high_sierra
    sha256 "0cd5ada4bc0ce1b16984afcd191e6bb080c0e13445752b30744e140262c81308" => :sierra
    sha256 "1a7b7a2ed0aaee7d51ba0168a44d50076459e8e84dbc8fd370010bc30f010870" => :el_capitan
  end

  option "with-static", "Build with static linking"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DSTATIC_LINKING=1" if build.with? "static"

    mkdir "build" do
      system "cmake", "..", *args
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
