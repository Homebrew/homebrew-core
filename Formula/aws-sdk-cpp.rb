class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.340.tar.gz"
  sha256 "2e82517045efb55409cff1408c12829d9e8aea22c1e2888529cb769b7473b0bf"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "5ee33d037d8ea5a58f997eae710d7643ad3aaa08ff4185dfea0641b66566cd86" => :catalina
    sha256 "a65980188b2db0f47664ec006d96f7e2a9d1a53bc9d59e11ff1e868044c31463" => :mojave
    sha256 "0d8103b4d82f1e7741a41c6b61dc58ec36c947cd332dd2e1d3dfe5ae2b287fad" => :high_sierra
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
