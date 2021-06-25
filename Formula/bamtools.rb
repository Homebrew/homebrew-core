class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  url "https://github.com/pezmaster31/bamtools/archive/v2.5.2.tar.gz"
  sha256 "4d8b84bd07b673d0ed41031348f10ca98dd6fa6a4460f9b9668d6f1d4084dfc8"
  license "MIT"
  head "https://github.com/pezmaster31/bamtools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d1822ce76a951623ebae2d1c9019dd302272de8a5183903ebd2d70f720b16b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "215573370903476d0d16d63153e5fb57ee94274e57277d43672babb60508f244"
    sha256 cellar: :any_skip_relocation, catalina:      "e06e5350260683c40d522ea80415d67bad57be49c30e5b534256aeac0bc5e3d8"
    sha256 cellar: :any_skip_relocation, mojave:        "5c1195094d84ce0e5ec63660597029dad111639e7212537c1d083444714ac294"
    sha256 cellar: :any_skip_relocation, high_sierra:   "cd3886cfb77b71ef9924d5475e4dbae2d42c4c66ef3880de33ca202855ce92b0"
    sha256 cellar: :any_skip_relocation, sierra:        "5e72d5b1b5b18551bbd91c7f3b7a2dd6e763b13add38b9a3a798bb5a450be64e"
    sha256 cellar: :any_skip_relocation, el_capitan:    "920e533776328d79f47bb562af5cfa00d855223818916e00614ee81d821f211c"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "api/BamWriter.h"
      using namespace BamTools;
      int main() {
        BamWriter writer;
        writer.Close();
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/bamtools", "-L#{lib}",
                    "-lbamtools", "-lz", "-o", "test"
    system "./test"
  end
end
