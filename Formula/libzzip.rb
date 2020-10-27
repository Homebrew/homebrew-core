class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.71.tar.gz"
  sha256 "2ee1e0fbbb78ec7cc46bde5b62857bc51f8d665dd265577cf93584344b8b9de2"
  license "LGPL-2.0"
  revision 1

  bottle do
    cellar :any
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
