class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
    tag:      "1.9.40",
    revision: "b733384b16945818fa5da5b73e410dea1e9ab9d0"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b663accd2c167b7808e277584f0d7584fa2e7fb1ea2a63dd313b849951aca17c"
    sha256 cellar: :any, big_sur:       "755d93e2f7917861abb4c1f58693d683c0e509122547dc9b631353de6918d093"
    sha256 cellar: :any, catalina:      "70a4cee2114286aec5e48238b95499b4fa78dd240adbe6eb008d5aa5ff81c775"
    sha256 cellar: :any, mojave:        "fb66bf923ceb6b9811e3c79c3c2ca7d3bb5b968dcad26cf2fba11cafa416e556"
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
