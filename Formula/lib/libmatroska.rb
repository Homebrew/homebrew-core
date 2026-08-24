class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.7.2.tar.xz"
  sha256 "f3e4d406daf7f1399962c43940e4a87de089474d5bcfbf2e6ca516e98bb87cfc"
  license "LGPL-2.1-or-later"
  head "https://github.com/Matroska-Org/libmatroska.git", branch: "master"

  livecheck do
    url "https://dl.matroska.org/downloads/libmatroska/"
    regex(/href=.*?libmatroska[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "551207828f6f2d1dffc9a8a66263a58370081abbaff0ca238510fd6806ddc023"
    sha256 cellar: :any, arm64_sequoia: "f56ce932de982e4bba15a674e8fda795e1e17299aaa230e7a34b9fd6b371ea48"
    sha256 cellar: :any, arm64_sonoma:  "c4933225e8d06c3d3f519947e1f97cb43f61ea3fd456c4f8c61d0c7cc300f482"
    sha256 cellar: :any, sonoma:        "d54eb3f5430a538cbb46f3a407a5c8f89bad60f45d2808c16dc974e6ab197e8d"
    sha256 cellar: :any, arm64_linux:   "b7454bda42e2d47e62d5c15e2c3671a6a3e10f7b867f0ead55b72bb83856f4e7"
    sha256 cellar: :any, x86_64_linux:  "020d7c996af2f93fa9ecc73cf6a20a038fc8138f71feffe1760ba74670ce0efa"
  end

  depends_on "cmake" => :build
  depends_on "libebml"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <matroska/KaxVersion.h>
      #include <iostream>

      int main() {
        std::cout << "libmatroska version: " << libmatroska::KaxCodeVersion << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lmatroska"
    assert_match version.to_s, shell_output("./test")
  end
end
