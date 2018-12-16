class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.20.tar.gz"
  sha256 "497d1f33f91eb4b64839f3cda567bae9bf76ae0fc5c77c3aa8723a360eedab2c"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "ca224ba81a80e20fbc1b2afbbce1f81f915c1cf2461aa4dd37268051bb9428e3" => :mojave
    sha256 "a4261ea5c83e7fd440cffc2f78bdef1641b4af5e0bd355c4beee02660c763068" => :high_sierra
    sha256 "0c9e8ae231f9befee65af936f2840b1ad20b5b8dfb48841684b8230398e1114e" => :sierra
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
