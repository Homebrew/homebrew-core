class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.210",
      revision: "72f1db5ce955de45d251766a30dc4bbc25931343"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d574402ab8d5ea5376b6db5ccde717605162717994313e1a7304e1a35337050"
    sha256 cellar: :any,                 arm64_big_sur:  "77fcfddb08155205b5ca09f07299ddac15babf9da9b259ef5c51ebd537c990a7"
    sha256 cellar: :any,                 monterey:       "4fcef25326f1b020c3e571a651f4a4da439d8827ac0931b86a2d347b96b13164"
    sha256 cellar: :any,                 big_sur:        "986f73af18ad372dc8845c28a648b4860c953ad3e51533ebb03d40683c8d4cb0"
    sha256 cellar: :any,                 catalina:       "28abf09b689125f5de8f7fd452d64d1c922f99c320ebd8c59dba9139be9ef4b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4851b407ab155524f3c8bd397ffc77934c0ff29242c0af5ab9d46ec520d28163"
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
