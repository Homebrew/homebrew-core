class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.250",
      revision: "3b4b42f5b9baffae183bbcdd8ac59285a4a0f847"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "330797f282e6d565189dc399a67618b92f0155428edfc701120a7139c7970b32"
    sha256 cellar: :any,                 arm64_big_sur:  "9be95f810be147be1fcb331ff617a36dc7093fcc4a6b25d768f432593bac1b84"
    sha256 cellar: :any,                 monterey:       "e51c05d8936e55c382d56bf6b1b1490edda28d0242aff014600e67a75d75bde2"
    sha256 cellar: :any,                 big_sur:        "601e6437f3675d7ca13f657e9d19629099d8d2350329fcd99205e23def0bd5e1"
    sha256 cellar: :any,                 catalina:       "c9e8e0299bc0342558586aee43943bd6fd67520ddad760702647966d3bace2f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47bf7e76df0a33cd8f5b23489ba5db92cd75a20b67a478cae43065e475eb240c"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    mkdir "build" do
      args = %w[
        -DENABLE_TESTING=OFF
      ]
      system "cmake", "..", *std_cmake_args, *args
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
