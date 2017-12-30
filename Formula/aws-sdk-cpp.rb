class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.3.30.tar.gz"
  sha256 "7b5f9b6d4215069fb75d31db2c8ab06081ab27f59ee33d5bb428fec3e30723f1"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "925edc7a011ada1997546e53a05a4f3b7d61c5f501ac98ec0e09066a3e7e4409" => :high_sierra
    sha256 "75ff1c867cc2c4fc1b90de8ab8c37afefbe1051154f48661a294378719922294" => :sierra
    sha256 "3198abc6e0c732342b0f0213437f110c6e95e51db65299f36d106aecfd2d10be" => :el_capitan
  end

  option "with-static", "Build with static linking"
  option "without-http-client", "Don't include the libcurl HTTP client"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DSTATIC_LINKING=1" if build.with? "static"
    args << "-DNO_HTTP_CLIENT=1" if build.without? "http-client"

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
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-laws-cpp-sdk-core"
    system "./test"
  end
end
