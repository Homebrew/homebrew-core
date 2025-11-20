class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.4.5.tar.xz"
  sha256 "4971640b0592da29c2d426f303e137a9b0b3d07e1b81d069c1e56a2f49ab221b"
  license "LGPL-2.1-or-later"
  head "https://github.com/Matroska-Org/libebml.git", branch: "master"

  livecheck do
    url "https://dl.matroska.org/downloads/libebml/"
    regex(/href=.*?libebml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b0156cbf1955e582256e75bdc14616f47df280ae9aecdf8b0b8fa5f9b5124aaa"
    sha256 cellar: :any,                 arm64_sequoia:  "2d15f6ce6df5cab89843ca6a7512a601b90ade25bbf7bcae17286664d72e11d0"
    sha256 cellar: :any,                 arm64_sonoma:   "77cc696e94a5ae2f8a4ccab765ff7adfe84ba6a804479c50d46ede90662d1e81"
    sha256 cellar: :any,                 arm64_ventura:  "23a888049e631dac6a467f726376aa4a00e5468910d1d37bc7bdc28ce2ad6d4a"
    sha256 cellar: :any,                 arm64_monterey: "21ced2ff88c6a8962a6fc1daa91c1e947e4090a0dac825968b077fdfa195c14c"
    sha256 cellar: :any,                 sonoma:         "1239efbef88129a1f69b8e160177912d565f10ac0ff311db0a82861755c24cc1"
    sha256 cellar: :any,                 ventura:        "d091018498ff6c3e107131187ea17cc489d7544751742eb89ce33b457bddc036"
    sha256 cellar: :any,                 monterey:       "1ac61d09f0ac6290a4aff9d2eec355ffc28c12499aab5331f355b101dcf3343c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a84f082ce4f338d50887d393e1b44965bb42daf3df9690f981d3e67de6298c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c102b368af523e56e6ebfca14a0e5ff544849992f06d90a0c7768aa8026d4378"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
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
