class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.340",
      revision: "028f4ca29fe7f6c613744a3d8ec23c4ead45357f"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "86258655b071552b36bbfbd42a5f48a2e6e6e4805b7942bf053b9863e7d27fdd"
    sha256 cellar: :any,                 arm64_big_sur:  "2656f9fb24a1be29c8a70779fabe1717a78a0ac04dc6217069a2fa98e523bd1e"
    sha256 cellar: :any,                 monterey:       "4e402f63c90bc99d99a5c6cda99d004c407ae9f3d029409d59d5a64c9b5792c7"
    sha256 cellar: :any,                 big_sur:        "533a40295827e78653409f48b1d75cf05f0258cd5280f71626c64b22e4fece97"
    sha256 cellar: :any,                 catalina:       "3ab0ccbdd143e7cfed238f96574c46e7fb26be78e07af4bb090cbb0b3a9aa96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4d3c3a6cf66e4303ae93c1301cc6583c7205715dbb91f5ab80a0aa6ca6dcfd"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

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
