class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.375",
      revision: "c1107e541b175e027284086bdb4a0bf6c98462d1"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46c633ed39c3fe2a05117b763a078775b139df4451d9e915c53b25faea38128d"
    sha256 cellar: :any,                 arm64_ventura:  "acbf832e9ab84c84cf8bbb882abb83654ec67d8a7e8cd8371448709616cfcdbc"
    sha256 cellar: :any,                 arm64_monterey: "af283db9d02f96ac2a0917192b88de72cf5705f32ec54993f46d7a6c0fff4cd3"
    sha256 cellar: :any,                 sonoma:         "f9382ae462768e71dbcc0fdb8f9955cea34f976bffd38b8bcace4d25aec53a4e"
    sha256 cellar: :any,                 ventura:        "bd1c2b911d8f78024a477db335b820b31d950c03a5cc88d910c62444970d7b72"
    sha256 cellar: :any,                 monterey:       "c42bc24177c8d6208fe9ff2d6d72d395396fe80885ae491a1b2599824149625e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272513f80c593d0fc9e4ffd027e28be4afbf386888202b5af9b14a1d76fc7d8b"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "s2n", because: "both install s2n/unstable/crl.h"

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
