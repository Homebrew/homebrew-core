class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
    tag:      "1.9.70",
    revision: "73842700df087083c1d044838b9b46651b60dcae"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "648125f257445fae253a11faaf35ca0a046bccc2ca15d94428e4919255b60f2f"
    sha256 cellar: :any, big_sur:       "bc2c4a5132a656664aa22e77abcd91767360d7195478b3babccabd81e4d4b393"
    sha256 cellar: :any, catalina:      "a3a114d8ca33111bb0f06a19e72bf2339b7232f7e34c4be47beff57426b0dbed"
    sha256 cellar: :any, mojave:        "6ec41a3f246b342e80075d40680483158dbf002a84ca5b1829aeb1e70bfc48f0"
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
