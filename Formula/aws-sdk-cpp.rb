class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.60.tar.gz"
  sha256 "e42dc9c799a36f72b9261074e887f8d180f2990916c6e49e7df3b7f2d641140d"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "e1d41a6f2534a8a5a5721fe4e87fd3c405ba85d079b2f247b25a70247b970dce" => :mojave
    sha256 "855aaf46ff273bf761d727472386fc75a1ee1a8bf8d5525fd8c78f918b076e0a" => :high_sierra
    sha256 "c5a7551aa339a36426bcdf01b22c2f905b9a468d5720e4b8cef52d9ffa0a251d" => :sierra
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
