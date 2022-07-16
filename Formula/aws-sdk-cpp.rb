class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.300",
      revision: "6dd2b5755a099ae4f5c8e3af156157dba8cd5cf0"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d3a877dfe3016cab89b0a26ff2b1d50b1755e3000164a02d3dd0a870f5195cd"
    sha256 cellar: :any,                 arm64_big_sur:  "62935b3b8b64782420ef08fb81c17bfe0a8d51660e46b8da2d61c8cb73f897a0"
    sha256 cellar: :any,                 monterey:       "1b044c8ed8337b00fe98af14300be87ac489a3a2249f5769b4dea08bbf4076cd"
    sha256 cellar: :any,                 big_sur:        "615fff27fe59ed2ee3447e21940e6ae08ed6ca3fde5c583ac69c6b1b98f196a8"
    sha256 cellar: :any,                 catalina:       "68389727781a28500dbe9bc74b335ec8ccd794d0617b36cb937664a8e1b01fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc0b51a77be5a7597004249300c8f8804d7245805290463967868949a0787563"
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
