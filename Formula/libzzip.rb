class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.72.tar.gz"
  sha256 "93ef44bf1f1ea24fc66080426a469df82fa631d13ca3b2e4abaeab89538518dc"
  license "LGPL-2.0"

  bottle do
    cellar :any
    sha256 "da81c94d36933d34fa6b280165d2d2aa3c98521e846f8b62b615373d32fb0fa4" => :big_sur
    sha256 "ebcf0e4129b0baf2da24946a2d4707c39b61821d5a5cab6231e15b740d0cf367" => :catalina
    sha256 "081779c8b26112cf75cf3b02cf87641e45bb25ce50994fc312ccff0229c413c1" => :mojave
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
