class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "http://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v6.2.tar.gz"
  sha256 "c4d1c358ab95b370dcac317fe1820e41d60460b22e450359ebc4bdd507bb2547"

  bottle do
    cellar :any
    sha256 "f9fd09b9bbd2939f9fafef85b6ee9f01589543c27865f6984ed4dfaee37e1f5c" => :high_sierra
    sha256 "36cccedf9f95684102b4639a2c208822c93d6a5fcb7fc4118af904a4afffe79f" => :sierra
    sha256 "cf0c9d21954f4ad0648d769159d92131b4c42803e02b5b382f1a1ea0c487cf0d" => :el_capitan
    sha256 "8796fbc088e1745e36129c63d7005a4f95029d2ca89fc442a7c42cff3659b0f1" => :yosemite
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
