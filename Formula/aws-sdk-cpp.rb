class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.4.10.tar.gz"
  sha256 "ab35f8b0141d4f99599f8969ee409a50724a5cf3ef8b00935dc350fd9a22a757"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "d92f1660b068bbce8dd8628f5f7aeba7abd37817cca92f6d4ed8d459e663433b" => :high_sierra
    sha256 "28cb0108767be330617cbb7d7471b2fc85e2aa0f80744678c4d5d183a9a83483" => :sierra
    sha256 "614472b224755362a13131402798735e40e76ed5b6be2331d710a4b413ebb856" => :el_capitan
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
    (testpath/"test.cpp").write <<~EOS
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
