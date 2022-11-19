class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.72.tar.gz"
  sha256 "93ef44bf1f1ea24fc66080426a469df82fa631d13ca3b2e4abaeab89538518dc"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "9850e8c458ac96d12f9b48f1de1e3b5697533ae1be8727210737b42d547c18cb"
    sha256 cellar: :any,                 arm64_monterey: "cf74798703189f3c2ecd72118e9e8693379ec1d9a1936ccc9be5cf333cce2d44"
    sha256 cellar: :any,                 arm64_big_sur:  "a7c81a822e4814e69bc27ee09c6fc7e2bbafbaacdb0337b90406b3ac7d627645"
    sha256 cellar: :any,                 ventura:        "cfd0f7bdbc338d26bcc7ffdd6bde1d518e23b270d08a28cb2d904fcd36b9d3c0"
    sha256 cellar: :any,                 monterey:       "ecf9e88530bcb24d5f5b531834d3f45a3d6c424e93ec24132ac062114a6d04f7"
    sha256 cellar: :any,                 big_sur:        "1a3322eea48b54ad64c93e36b3c61cdf3175b96d01b39a35f6a70cb9c079b92d"
    sha256 cellar: :any,                 catalina:       "8c6c6c3bf2febfc90d54933e232cc64c5adbb3a8afcf7885725190c73ee5d350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1ec7a63878216eebf0edda2089ab91a36c44928887f27e995299c75243e3cb6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build

  uses_from_macos "zip" => :test
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DZZIPTEST=OFF", "-DZZIPSDL=OFF", "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "man"
      system "make", "install"
    end
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
