class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.60",
      revision: "6e9ef07d76cb9403a1b8626efa2eeff8a82c53e8"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "569257c99aaa8e7edb9cea15f455be27bf1010e91d9171a30cd1800624729dc4"
    sha256 cellar: :any,                 arm64_monterey: "436b76e52e8f876c7ebaa761f716295e673fb9c4ea1384621b140c4a691da095"
    sha256 cellar: :any,                 arm64_big_sur:  "0841d203e690df5b35c253bd85f9a3916864291326da1d411916eb5c89c78d65"
    sha256 cellar: :any,                 ventura:        "8564f9f5e0afa63df7df679b5685d76d6b4181ebd95c46f168651551686e7a8e"
    sha256 cellar: :any,                 monterey:       "ef97853949cf20cfce65ffb33ff1d4f82f17c2a11373d9e31fa06d9d2814386f"
    sha256 cellar: :any,                 big_sur:        "fbb93ceb1d8e1dccd248f804f4c7de2d854f36345735081ae6420c2431288314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a3c11f4cb11b5ace6d74946daeb223aa7bebcec9502907bdc10bc35a4a537ba"
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
