class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.90.tar.gz"
  sha256 "ffa501fa00e18d789cd10c768b55a2907c314816f09bcaf96e6d816a5b67f6e7"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "2f2366564f1ded7d77b0ffc3a0aa79a37e5dd0c1cd5aaf0d6c8ebbde49a42a0f" => :sierra
    sha256 "97e35c8ef73b86f96c1f6a88d5967c285c3d8b3feeba70ec9f456aa2f1ecb9ed" => :el_capitan
    sha256 "1ca49d9a3c7e71933cd42768b055855465fdd5c10a01508f3153de7bab733db9" => :yosemite
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
    system ENV.cxx, "test.cpp", "-o", "test", "-laws-cpp-sdk-core"
    system "./test"
  end
end
