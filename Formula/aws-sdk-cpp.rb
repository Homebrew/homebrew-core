class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.170",
      revision: "fb8cbebf2fd62720b65aeff841ad2950e73d8ebd"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "15a4314b000727b2c70f783c1be8c6f34a9aba93a486f605b97fa1ab74054d15"
    sha256 cellar: :any,                 arm64_big_sur:  "940ed97bef0bca4335add91739be4dc58cf9e1bd9ddd82bdb12876156685280a"
    sha256 cellar: :any,                 monterey:       "d141e12e8bb363b795ff4be9b47f369f59dd79bcd3d0cf6070323767eb45f914"
    sha256 cellar: :any,                 big_sur:        "58d8b568e0e70135742416841733b4eaa7d13b27b4ad304f6485a92ab201ef90"
    sha256 cellar: :any,                 catalina:       "ad22353c016ee5004b18bf5823a1cc3a6df6e84bd8bbc0b524a3e845a86ca564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "877a28bd18a0101398232c6ca419372f2262cf4adc90980c94d858eaec2bb96b"
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
