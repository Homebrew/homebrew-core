class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.150.tar.gz"
  sha256 "40763d2b79b59f6f3b59d3db4f0bfde96700f8641d715518f927691170cf2e5d"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "60a46d3864461c2215630c72911296658661a31e442de2011a4b44239179531e" => :sierra
    sha256 "682fcb90ae2222c6344263798348f679b0d67173d0d9a2aaabadaa70439c5a97" => :el_capitan
    sha256 "dba7929a9eafb043986dd2fea3f4310a5aaf359862fdeb1ea430a4385d401fe6" => :yosemite
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
