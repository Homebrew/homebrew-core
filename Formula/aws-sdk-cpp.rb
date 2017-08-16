class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.1.30.tar.gz"
  sha256 "4c5cca16747231cc5374f2fa2cdaef8673b392255ec425bfdab13659b017f8d3"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "a94456466f7c7b1c8c0ed0094184627c7c33b71e2f6ab2f5f9d1612896ecbbe1" => :sierra
    sha256 "ba876d093ac0080fe4c3cbdfdc3e2f75a24aa3bad60a59b01b7ef6c9b9d0dfdd" => :el_capitan
    sha256 "7998efa5ed98dd55fab51e7c84b537b8c7dbe9b6b8424abd62e2bee13fa7d4d3" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
