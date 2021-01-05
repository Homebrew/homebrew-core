class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.72.tar.gz"
  sha256 "93ef44bf1f1ea24fc66080426a469df82fa631d13ca3b2e4abaeab89538518dc"
  license "LGPL-2.0"

  bottle do
    cellar :any
    sha256 "fec84d2d418c645f0a736922e04421c14ee6cd19f849d3a3e3657c72f23b743e" => :big_sur
    sha256 "dc85b70f378aaaf57f17c6a945e7a36c9c125941651de6d2c2d0c5308befd3dc" => :catalina
    sha256 "777bdcb24dfc69b7d91298949814a0c54313c251ae80173b636e2baae298f228" => :mojave
    sha256 "1663861e1170f3e34b94580d0905063d48703717efbea616010a239eb135f1e8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DZZIPSDL=OFF"
      system "make", "man"
      system "make", "install"
    end
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "/usr/bin/zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
