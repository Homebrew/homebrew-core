class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.110",
      revision: "b3f8d3def2f3099f73f747d93bfb13d5b5e42597"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "62ea83ce1bb1182e697dd6d8fa41a9005652cd7d596e61c99aa395794621e0fa"
    sha256 cellar: :any,                 arm64_monterey: "dda6f30f1fd32491f17eacd6fd5b5b48476affb3ddeaa7084507d216c953ea80"
    sha256 cellar: :any,                 arm64_big_sur:  "c272e31aa23a12fa3c79c34bf9a75c60e41391443593d1c020d311baff0b52c1"
    sha256 cellar: :any,                 ventura:        "ea558b2f4037378e6dc189aaea04921c0ba0108dba00037f3b105b98f67873c3"
    sha256 cellar: :any,                 monterey:       "a03d307f43ea1ea5017f65bdcba21f5e3f56053995b1acd0bea4505ecc02b3d6"
    sha256 cellar: :any,                 big_sur:        "e172d45a9f0c296a87cf8a4c8cb7c4b12df2bf12447af4c5954e540bce2dcfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64b5dab2f5d264ff3d46850b6bfa3ec0c765d128ef5e93d24d36083b9e89ec02"
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
