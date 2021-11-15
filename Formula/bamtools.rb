class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  url "https://github.com/pezmaster31/bamtools/archive/v2.5.2.tar.gz"
  sha256 "4d8b84bd07b673d0ed41031348f10ca98dd6fa6a4460f9b9668d6f1d4084dfc8"
  license "MIT"
  head "https://github.com/pezmaster31/bamtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da59f26d70c68c71a6c6a600c21be2804dc703e23d31eea20ab73980037b0e09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cad31e2a176762fdaa4aa0b311509b30a339395b6da469f005c667b75ce99296"
    sha256 cellar: :any_skip_relocation, monterey:       "019cb251644784e10943797901abf914a8940f12dee84df5811759a8cb46150f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c213c66de8e7ed7a13b07b41b6ed3b71509a28121cf942c3b76cd735efa6c3d"
    sha256 cellar: :any_skip_relocation, catalina:       "e978a4b284e0905486557a2a3ccc224303900d38970e4c0a9b6ee6886c9fd743"
    sha256 cellar: :any_skip_relocation, mojave:         "4459a3ddde44539d67dec67bd40f3f7f38f98fbaa883db7b786aad410bd9cff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "373dc0881a1cab120df3c9ed35662373ab46066f413483242dcbc782f77e45fc"
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
