class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.101.tar.gz"
  sha256 "e305204b393a22a4d30f605cab68a3637baf63a33aa4cf71d4d1d56c3cb8e7b9"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "7d9647768f2e58e70e42583736bb394c0b6c84aa39215e560fcb5dd067f96d7f" => :sierra
    sha256 "a52b057bb85af17d867d18dfc239339e6c56d78f3988c7544d7b7bca4d38a210" => :el_capitan
    sha256 "0dfe14f7de113ca7b47f495e3bc3d0ae77f4bc35f1267c48bd9ecb4d6905accf" => :yosemite
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
