class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.180",
      revision: "fbc7cab455ffacf2a911a8ae88f0840408f1afbe"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c893f9cba39da86975eb393e370a036db6815015562586c658710a48938c848b"
    sha256 cellar: :any,                 arm64_ventura:  "7aed22e1247d2922b6c4eb6ee043fab0ae64993d0f56df37c43ec1d8bf95b9b1"
    sha256 cellar: :any,                 arm64_monterey: "cec3cedf2daf615be4bd1f6355ca5720ee2820725c849a2ff94838161ee421eb"
    sha256 cellar: :any,                 sonoma:         "167cef533d0066bc8f53cb395a880ccb8ffd0400db0f2e3b55cc364e43e08a25"
    sha256 cellar: :any,                 ventura:        "983033386a5623d9b323a1b1f19bd448e5a68b19b184d225a72d718f2343d138"
    sha256 cellar: :any,                 monterey:       "db43c8084ce05023f84bf87bde181b3e45a0aae5802ba62060435ce91f28a52a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0866cbbd7c17a0e7447ae08c83b4f0206df3ff804075cbc6d3623add239d4fa7"
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
