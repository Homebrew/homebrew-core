class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
    tag:      "1.9.10",
    revision: "3c2751d0cfd52d20acb49e5308a33fcaca5dc9b8"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "63d17e09da7e5439f33f3d9f2eece8419a34ce4f6a8bc98dae45edaf00df1464"
    sha256 cellar: :any, big_sur:       "8951f718abe89c49074bab5484f5c2b86fb0486f95b7304f0dc426b0958f44ea"
    sha256 cellar: :any, catalina:      "b2e668efe353634fe7c8d342c65ca2c036802f160ad31bc1103ac8ca7a5e41f6"
    sha256 cellar: :any, mojave:        "1cea426b980f0d7a308d19e8f8526b5b460bf32ba146083ba4dc7b99877c2e23"
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
