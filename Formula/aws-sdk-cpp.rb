class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.120",
      revision: "9ac19a89650cb5f2215d1fcfde0ff79618824009"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "af6b638f50ee26e3ff46439d0390b2b309f3ead1769bf217605098fb29f949dc"
    sha256 cellar: :any, big_sur:       "bccf5bd2cfd2c08ff280d876d1f065d1a72f25df968c15b388f8dca68d91d38a"
    sha256 cellar: :any, catalina:      "b1e03ebe9c31ebf8eb65213a4003e13287c87ac60ed2cfae9b10a287d08ff90d"
    sha256 cellar: :any, mojave:        "9b1a9bb1435a2f1f616265ce7a8541c9c80d31f9b0f52f5906b43207b52881c0"
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
