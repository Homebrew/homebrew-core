class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v7.3.tar.gz"
  sha256 "bbf4a068ba220a479f3b6895513a85ab25f6b1dcbd690b188032c2c3482ef050"

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
