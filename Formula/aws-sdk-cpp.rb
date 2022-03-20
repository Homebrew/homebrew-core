class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.210",
      revision: "72f1db5ce955de45d251766a30dc4bbc25931343"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9afc7b53adc909526153123e08826ff64acebab8994fa68177d5b6f63bdf125f"
    sha256 cellar: :any,                 arm64_big_sur:  "8963cd54dbac6c2c632e6a4275f3c0558f8f3c8ab79609e8b3df3c300146c521"
    sha256 cellar: :any,                 monterey:       "2bbe9315383495a9226dbab6be517f0fca1fd03080556ddacf5fcc05a89f605f"
    sha256 cellar: :any,                 big_sur:        "3214a1744075a534ddad29b2df59107f64855ecd31aabd4c94e1cbe8228e0ed9"
    sha256 cellar: :any,                 catalina:       "61c78243685a6cbc43f2a4d3389bf71c0866c7c2f9a3587383eb3e5c6fd2abdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3c4ae8c76ce983e6439eec85d464fd92b884ae4640e369262e8e0494fc01f67"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

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
