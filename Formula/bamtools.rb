class Bamtools < Formula
  desc "C++ API and command-line toolkit for BAM data"
  homepage "https://github.com/pezmaster31/bamtools"
  url "https://github.com/pezmaster31/bamtools/archive/v2.5.1.tar.gz"
  sha256 "4abd76cbe1ca89d51abc26bf43a92359e5677f34a8258b901a01f38c897873fc"
  head "https://github.com/pezmaster31/bamtools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a504c278fea868f97003fa89ba11596d296e89dc5223a1ee2d7d6a244e0cd36" => :high_sierra
    sha256 "8360ea6b47e818a342924c72efcf266977c77a6d0c507500825c9e89db5618c4" => :sierra
    sha256 "30e7b3c26dc078f5436940147082bed4ebca1023a4eb8237fe1dfccfebed18d3" => :el_capitan
  end

  depends_on "cmake" => :build

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
