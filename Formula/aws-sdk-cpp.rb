class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.130.tar.gz"
  sha256 "5dd09baa28d3f6f4fb03fbba1a4269724d79bcca3d47752cd3e15caf97276bda"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 arm64_big_sur: "f898d63526dc2a454e0c936b01e12209714c63952ab2ac412f5b34bf95dfb724"
    sha256 big_sur:       "36e94d82731bcc77a910a870ad543ded1dff1034cf996ca08fa058942514a9f0"
    sha256 catalina:      "4c0a1accc76ce3392992782b960e42331851fb7aa26daafec54e30e0c209f019"
    sha256 mojave:        "0b9ca868ffd75a9e235e12898049df2e12ae9ee6454a952daf0ff8dc148161cb"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
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
