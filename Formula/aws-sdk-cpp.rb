class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
    tag:      "1.9.60",
    revision: "125d652178717231c97757aecef6dbd50a47ccc3"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5e21ddd503bab8a8e7e5162075fd8b896c36d0e75ef4b752573e744d5277c260"
    sha256 cellar: :any, big_sur:       "536a969fd4d6e4e33a7eeaf405d28e7b7bc14c573c06046236f94303e63e7331"
    sha256 cellar: :any, catalina:      "df2db5f6cc7afb4300ce38d3feba23ff020618dc0b318ba29aa5f5b8caf282a4"
    sha256 cellar: :any, mojave:        "c0f20125c57e868a6a5564c1157bd99390db771610c961dc5acee2559cfe9575"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
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
