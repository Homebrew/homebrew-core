class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v7.0.tar.gz"
  sha256 "cfe61451dcb2d0fd9e7beadac55a1a6399acf9223615b0df50e9f90e2f1a3432"

  bottle do
    cellar :any
    sha256 "1cac8717470a1a7edf3d6512e04be73b7712bc46febcfad05ef90cc2522e85b5" => :high_sierra
    sha256 "9d07453e002a227aac81523b06e2a2224e1dd6e3e727350c92c3cdd531685300" => :sierra
    sha256 "2506d0b7a7a5aa370010b4713bc4725470f4baa7d93f73a6f49ffdbc108c18f4" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
