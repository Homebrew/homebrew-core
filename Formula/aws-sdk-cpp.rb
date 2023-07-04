class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.113",
      revision: "ece7e32dbca87b3fbc7edf0e81d00f328f4b2b07"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a13f26a0724a327a784a3387ce01b06c5551d67b3b3dafe99a48a3c1957ae29d"
    sha256 cellar: :any,                 arm64_monterey: "5d767fa720bb5bad582b3bf507d126f4d6b02328d097a1b2870a57cd7e1eb0cb"
    sha256 cellar: :any,                 arm64_big_sur:  "36231cc47dee93694dd441692008393ba606f5484db3357211a2144cb3b8c698"
    sha256 cellar: :any,                 ventura:        "04d07dfcd529d4130efc23ea66117b57768ad4b8d18400f7b6daa1f56db0f385"
    sha256 cellar: :any,                 monterey:       "d02d76ac0b440c22d7abf708812d9e58ed064ff2100d562a79b74c7f152a5a23"
    sha256 cellar: :any,                 big_sur:        "1241ac6e869d5bdd608b287693a095565cc0f8b183377334591ed802d592ff8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c086ee5be71230fa2d37423d2ef38316e6017a3cfc7aba47dd63fd3c4dff7c8"
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
