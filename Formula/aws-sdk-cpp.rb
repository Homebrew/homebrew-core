class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.90",
      revision: "bc9ec9391d155a031320395e3079aa95fa30dfd3"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "55adcd5e682cf74aaccac17bba619ec27f637f365d6f8ecdf01ecca7f0aa8635"
    sha256 cellar: :any,                 arm64_monterey: "7e9287de0c6c8c912558d01814d36bb3b0bb9e57c3a171aaaf4337ba34009e17"
    sha256 cellar: :any,                 arm64_big_sur:  "61545698dca59e3d1e9d5468b09d63599fc4c703d92738529fbd2a7d8afa4814"
    sha256 cellar: :any,                 ventura:        "f30c7c29b7bb3b24481dac3a352e1b0c7d2256f337aad7ead913d5970033ec1a"
    sha256 cellar: :any,                 monterey:       "d2eda68c12e8bd4a3f63710110fb1b81f45b558a39e45158bd159f95dda2660f"
    sha256 cellar: :any,                 big_sur:        "750f643ff4b077c6eca0e95c844abc8b8ab5a8a64be68df14634742d65cfb929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73910e01268dcf1416783ca6332d20a94a67e49f9030b80b2db3edcc56c9e7cc"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
