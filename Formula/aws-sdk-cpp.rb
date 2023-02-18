class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.20",
      revision: "599450bfaacaabf8f104484ee9e723cba7c19412"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b2d8517727a231afdcaa94a7dc155dc3afbd538af6aadbbd9a689abdd9aeae35"
    sha256 cellar: :any,                 arm64_monterey: "4163f5b8686818eb07b752da7bd583a6b6d6ef34bebbb8c10d10e891f285480b"
    sha256 cellar: :any,                 arm64_big_sur:  "58a4bbf15d56d2de17d4b4137846d17ab3bfa0c05faab086f6153e023cce4142"
    sha256 cellar: :any,                 ventura:        "821073b02995904f81fc198518e9d9c9c920922b729a3e2dce680bac13bee190"
    sha256 cellar: :any,                 monterey:       "fec32766ad7ef92c20a80696b0b3bbb5781e83cae42f097056fe719208f369dd"
    sha256 cellar: :any,                 big_sur:        "9a7d07f82d3fece2e72c8c7a05940a58004befd82921741dfe9b43950a572526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db8be9e047ed0905ebac98beefe345f0c72beab803c4aed3a0a1898608724e6d"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    # Work around build failure with curl >= 7.87.0.
    # TODO: Remove when upstream PR is merged and in release
    # PR ref: https://github.com/aws/aws-sdk-cpp/pull/2265
    ENV.append_to_cflags "-Wno-deprecated-declarations" unless OS.mac?

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
