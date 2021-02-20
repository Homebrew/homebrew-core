class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.72.tar.gz"
  sha256 "93ef44bf1f1ea24fc66080426a469df82fa631d13ca3b2e4abaeab89538518dc"
  license "LGPL-2.0"
  revision 1

  bottle do
    sha256 arm64_big_sur: "50ada2e93bb60398e4a65a77c2ae5d3c5010a6d2d00a96a74de06ecf735b38d4"
    sha256 big_sur:       "5b805b4607fcf22e7b004a24c4b219d735bfbe7ac0387b5595ea1dd1866536fb"
    sha256 catalina:      "9ded307d1427e930bf5b7720a14b94a63f03d0a10ecb93e00ef695ae98ed7fa2"
    sha256 mojave:        "430a9fc127c01b7c672a09406c2da7647f2913664f09c4086976cd4c5df977ff"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DZZIPTEST=OFF", "-DZZIPSDL=OFF", "-DCMAKE_INSTALL_RPATH=#{lib}"
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
