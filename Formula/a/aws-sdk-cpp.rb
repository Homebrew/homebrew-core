class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.420",
      revision: "2cde9b1786bdbb3182faa93ce28d6e44ac2fe7e0"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f8cb17ed2035e8544940fcc4e760e3f5d34934670a7607d899489d25c08e68f"
    sha256 cellar: :any,                 arm64_sonoma:  "98dd61af5dc947d0abdfe209e4f6d5c0cfd71714769fb085d1624558c6992c47"
    sha256 cellar: :any,                 arm64_ventura: "f9b9abfbf0718d0561e64f2f491133b0498755a07b608552eafe75d4ee00d2e8"
    sha256 cellar: :any,                 sonoma:        "bdac7c5f8f12203d318d2947659b209912421e6c0b810d948bafac4a883620dc"
    sha256 cellar: :any,                 ventura:       "60ac1626a8bddeb232ea49ef8a64af3959b4835ffb96de48a52b0a3cb7758182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbc93a135866b616d5e896f2a14342ba65fcf9b2ebe76440682b856bd2a81830"
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
