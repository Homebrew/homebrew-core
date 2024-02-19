class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.255",
      revision: "c6311a18bf4973cb7062b190cf9b9b3bc8165100"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab97519d70c52a42b6c208d947e49f735bd5e433b8993cfb690d68455ca29bf9"
    sha256 cellar: :any,                 arm64_ventura:  "46547fb2237fcfec3795696dc9d7a19e97e849f094df9e3f9e0502518c6c67ed"
    sha256 cellar: :any,                 arm64_monterey: "83a33a9b19d177ef9168b5c925bd001d25ecbfb4a00edb30c256468f511479cb"
    sha256 cellar: :any,                 sonoma:         "f0a4bff533cea37dc1fb4890c53cf37a12d89d5d394437c41ad109dc7dc6de3c"
    sha256 cellar: :any,                 ventura:        "ba87b1b4b1aa80a435572276742a9d40dcaa253cbc357b54b1085207261bc241"
    sha256 cellar: :any,                 monterey:       "d86534712d601a950b0e38087e4765e1b0cb1af9d01903cbfb2e463c82b732c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b24365e72d965316c86f4aa17b64dd35282b0fc6c53c1b9bb4d4b1c92c5a418a"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end
