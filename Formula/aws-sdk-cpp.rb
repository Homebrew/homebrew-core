class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.320",
      revision: "9a3e6e8e31636ce341a43355d58a2717033f2668"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cc3f9114e7ce1a83c6d2701761c22a2eceebdbf81a9c2108f79dca024dc1b35f"
    sha256 cellar: :any,                 arm64_big_sur:  "99249c813c5a119f76313f701465c1be617e5828d9737edaf460ae8900c568d4"
    sha256 cellar: :any,                 monterey:       "d6f84409ba7037998d9e9857506227623890f396df239877a6a3088d6bc9df0a"
    sha256 cellar: :any,                 big_sur:        "f002c9f7d14dad4cb8b4d819160ee7233d4d26b8a2b1a103f65ed8b740dbaef6"
    sha256 cellar: :any,                 catalina:       "b523cdf15137e2ad74be5bba21eecca2cd38362f268ddf66165dd9ae6ba6d10e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cae66bcd17a867b8ca60567821e18d676bbfb71317a1a49262ac76db3e1b994c"
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
