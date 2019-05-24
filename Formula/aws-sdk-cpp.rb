class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.110.tar.gz"
  sha256 "0e85cef16240f870128916191ae3fe95e921b3f2d3087888642a466005997712"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "0a131f0ea5b1deae3ce861fe12be40b5be927183468791286ec7e87e34f2b73b" => :mojave
    sha256 "160dea9edd3d758c33489d46c569087893e3ffc34af5896a524aa256928962f6" => :high_sierra
    sha256 "3a33219d2cb8dc211e31ba457275efb49b910f62d9fb3f5ec24b2f775880c018" => :sierra
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
