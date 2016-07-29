class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.13.10.tar.gz"
  sha256 "4de6f67585afccb6c57bd0948766870375aed7b41d5541169f274a741b12540e"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "5e508874d244afb50a1c330152249808abc5cdaa43dd0d838dd74fb2e9908238" => :el_capitan
    sha256 "a56e38e6cab9ba55cf81996de9eee338b103bff15c0fbc8902f5dfa596545810" => :yosemite
    sha256 "5d5ffdaac47dfc02da76f0e8a61dc4311e5e0f164114ffd309f7ac05774a6c9e" => :mavericks
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
