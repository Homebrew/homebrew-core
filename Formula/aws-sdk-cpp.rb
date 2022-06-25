class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.280",
      revision: "c396dfb4191cb46d3e08972a8eaf0b786975f206"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9cf4e5050e66db6b89ccd26cf724077e5417ad4fb10774efd610848505bb1af0"
    sha256 cellar: :any,                 arm64_big_sur:  "f26a96cb4ec013e8c6ebe08ad33c767f470b134795887b08995aef803899b2aa"
    sha256 cellar: :any,                 monterey:       "19634a646e289435d22652ef7b3875c28c0ca614ac1ba6f629336649603c87ac"
    sha256 cellar: :any,                 big_sur:        "5b4d830558fe92cb62710118b1427e694ad4045651dc9a3f847b8a7654b4e481"
    sha256 cellar: :any,                 catalina:       "743b59b9e3460f2ada6c2392f0cc04341bfb409d17e735ecebae5ad1c1859fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f91ee5afa81a5979334c4b1a828041a5748e462f6fb600044b438bbedd109240"
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
