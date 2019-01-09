class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.30.tar.gz"
  sha256 "a6203e7b398ceaf348d4ed05a7de398b17b35f02705b00cdd3e2354366ebfc0e"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "abff5c371e8b584c09cbff8e74e3bc3be3efa5abd8634537c3f0947cf1b96e1f" => :mojave
    sha256 "b39e86931af791de2b2eab0be253c5c06ec5f58bb2bc09b46c7daf674dd18692" => :high_sierra
    sha256 "a7480c19a2a850c5a3b105fd82b745b04b86244cec74ef96804e7bb5324c7272" => :sierra
  end

  depends_on "cmake" => :build

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
