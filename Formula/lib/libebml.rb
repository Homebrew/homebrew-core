class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.4.6.tar.xz"
  sha256 "d06cf1d5ad89390389eeb1eb7d50f70b55ac7538b19aeac8859eed3f2a9908dc"
  license "LGPL-2.1-or-later"
  head "https://github.com/Matroska-Org/libebml.git", branch: "master"

  livecheck do
    url "https://dl.matroska.org/downloads/libebml/"
    regex(/href=.*?libebml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bfcc8e198706779177c919876a4b3c026f018bc310b6de2d06ca903a74a2e218"
    sha256 cellar: :any, arm64_sequoia: "4aaaf7ee5c09ff50b6e76ac806d7b28c22fb463e8a22c62c2bd03e5aca3b7f02"
    sha256 cellar: :any, arm64_sonoma:  "c57c38560b3faef5a136b5a1769b283c4e4ffaaf5358b43a787c3dc70e496bb4"
    sha256 cellar: :any, sonoma:        "d5441e7cdbe0349376d9eed8e73f65636db565ebeb8e7977e12e06e5ab3e98e4"
    sha256 cellar: :any, arm64_linux:   "40007ef0838462c76a47105619dcdd81f69dfa889307e50e1ea131474b27095b"
    sha256 cellar: :any, x86_64_linux:  "e50729ec58c7bdb08d793b54d4554ad1cbe745950829b125cfb0cbe3d8260fec"
  end

  depends_on "cmake" => :build
  depends_on "utf8cpp" => :build

  def install
    inreplace "CMakeLists.txt" do |s|
      # Allow to use newer utf8cpp library
      s.gsub! "find_package(utf8cpp 3.2.0)", "find_package(utf8cpp)"
      # https://github.com/Matroska-Org/libebml/issues/344
      s.gsub! "target_link_libraries(ebml PRIVATE $<BUILD_INTERFACE:utf8cpp>)", ""
    end

    ENV.append_to_cflags "-I#{formula_opt_include("utf8cpp")}/utf8cpp"

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

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lebml"
    system "./test"
  end
end
