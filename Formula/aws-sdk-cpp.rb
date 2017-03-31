class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.93.tar.gz"
  sha256 "2d5d897db3f5d8fecd85707d38f06f2749cdf8e7396da71b24590e99f77e1e1d"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "193c3a1fbe9835f80c0f5459acdbb8b464682560ce2cf2b2d14180c08a2b9ccc" => :sierra
    sha256 "895eaf55497e11065000a36cffc390b3ecbcffb5c42c045c4725887aa88aadc4" => :el_capitan
    sha256 "7985b9c3d4af5978b868e9ac5e191f67cf37c6b63006e106a32ceb1d9608dbb9" => :yosemite
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
