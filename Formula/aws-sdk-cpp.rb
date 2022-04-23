class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.240",
      revision: "716c88324bb292042183d52888bf3bd0bbd471ea"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7945bf718de62047a5579e24c392ca7606b0d94bd74bbf53a7b3a11e4e0a7a38"
    sha256 cellar: :any,                 arm64_big_sur:  "58a56647c3f331741619085c1862bf37d930f9874e9731588743555c02540544"
    sha256 cellar: :any,                 monterey:       "e1c4b7f80b5f19b7399a3d264b13de05d75a359f416782cb51b880f3e2d0ec36"
    sha256 cellar: :any,                 big_sur:        "d3e40ba1c39a4bed518e4717e3f65f38506c7c414dbe9397ac0083a6560135f4"
    sha256 cellar: :any,                 catalina:       "dab6775a28448c00a80e6b7a54f8a05c785d99c0c4900514324a619e32579e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c47c6ac4797c108cd2d31b04b1c727acf07cc4494e6d2e1c7817f6c185a47f4d"
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
