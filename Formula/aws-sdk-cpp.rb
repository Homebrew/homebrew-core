class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.360",
      revision: "a6da713fe5992964fe703ba183778926ad809b77"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ac71eb26a78945f09f1e38340ee8799b0d59779876bc2a74ad4eddcc9a873738"
    sha256 cellar: :any,                 arm64_big_sur:  "b5c1312065a4194f5259fd1a7becd2c52da14ac3d9510632dc8ca08f0225dcde"
    sha256 cellar: :any,                 monterey:       "445adeb589ae1d34905a7fd8e2f16535cdb71629862ed986845a4df76beef40c"
    sha256 cellar: :any,                 big_sur:        "29527852723b6d02648d0462a0837ce8c3ee318bde456a4a5fae7439041aca47"
    sha256 cellar: :any,                 catalina:       "587da58ca71f0f82eebd9fba22e081eae72051364da6974673c23eb941312732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d3941bb2af22f9810534c6066b2715e420df11414a435a2d9698f706760d100"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    mkdir "build" do
      args = %w[
        -DENABLE_TESTING=OFF
      ]
      system "cmake", "..", *std_cmake_args, *args
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
