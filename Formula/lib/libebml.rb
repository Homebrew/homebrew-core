class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.4.7.tar.xz"
  sha256 "5b08214f929ee54c6187c370f84235fc9d0f2a2258c4d320d68eae6e2bdfd3f7"
  license "LGPL-2.1-or-later"
  head "https://github.com/Matroska-Org/libebml.git", branch: "master"

  livecheck do
    url "https://dl.matroska.org/downloads/libebml/"
    regex(/href=.*?libebml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d5c5e9913544130b8d5b7eeb1ed4027a62520c07bb1546e43d16707a7386a2d"
    sha256 cellar: :any, arm64_sequoia: "5b60dc631dd96becbdd1ef9aa17711697feb3cc57c478b8a1248600a2c7fddf3"
    sha256 cellar: :any, arm64_sonoma:  "03cf729ca8007eea4bbb7130850137a392f15c22e25fa0b1b10dd6483e2ffef2"
    sha256 cellar: :any, sonoma:        "039207dc37ef7ba4ba3cd16e88a6c306ea503976182d5c3af90bf1790b305354"
    sha256 cellar: :any, arm64_linux:   "0a75bcd86d089f537a3671b2d528e135896f064134cbf59fb8aedaaddcd526bd"
    sha256 cellar: :any, x86_64_linux:  "55442b033a637e363bd95d2582320402d886ff644e1dabd70f69161b14d1517a"
  end

  depends_on "cmake" => :build
  depends_on "utf8cpp" => :build

  def install
    args = %w[-DBUILD_SHARED_LIBS=ON]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ebml/EbmlVoid.h>
      #include <iostream>

      int main() {
        libebml::EbmlVoid void_element;
        void_element.SetSize(1024);

        std::cout << "EbmlVoid element created with size: 1024" << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lebml"
    system "./test"
  end
end
