class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v7.4.tar.gz"
  sha256 "ff9b9e8c6ca3b5c642f9a334cc399dd55830a8d9c25afd066528aa2040032399"

  bottle do
    cellar :any
    sha256 "3a2eac9faab2782f53331a2ef034471502e40b8daaab6bcd069cb7c31837172d" => :mojave
    sha256 "432bfb6ee8be028223865e795ed2d0db05cdd70acbea9f3f848f0cf9b7529702" => :high_sierra
    sha256 "98a263207135a700cecffbfd2c00ce3c4172cd719fec3b80168a228a529e493d" => :sierra
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
