class Liborigin < Formula
  desc "Library for reading OriginLab OPJ project files"
  homepage "https://sourceforge.net/projects/liborigin/"
  url "https://downloads.sourceforge.net/project/liborigin/liborigin/3.0/liborigin-3.0.2.tar.gz"
  sha256 "2581420d427481eee8c371ad5b6ebeba83bd7faa8df117c7a3f7d3250b4429ca"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/liborigin[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28bd38fca29a6137db214a6d8c4b151705d5d1028e844aa3c004eb253bf8627b"
    sha256 cellar: :any,                 arm64_ventura:  "ca63266ed035f00907bd903e8005eea61a165897074fa66ed6b265456ebd9ac1"
    sha256 cellar: :any,                 arm64_monterey: "0622ef79242ba03c3ed38ec3a42b05c94488369371cfd7d0efb2e6b0b26b08ad"
    sha256 cellar: :any,                 sonoma:         "7984988756f10f27e88653cc4f61d69abdc8241d1f3c49da9f1be8d0b6a2e83d"
    sha256 cellar: :any,                 ventura:        "2486e161b330f0af0015f9234f5ca3d45f192aa88f0b18c9cb8f0718c2135ed3"
    sha256 cellar: :any,                 monterey:       "08d242356b0df10fcea02d69bd93f039e3c1fcecf170eb3b497f53d99e6a73a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ab6103c2fb90a0349ce227ec251c72188cc0a0c77dc145305383c8f589e9eb4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <liborigin/OriginFile.h>

      int main() {
          std::cout << "liborigin version: " << liboriginVersionString() << std::endl;
          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lorigin", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
