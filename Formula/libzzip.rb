class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.72.tar.gz"
  sha256 "93ef44bf1f1ea24fc66080426a469df82fa631d13ca3b2e4abaeab89538518dc"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "460bbbc8e5d56c82fd67e731e7abba29244400566292bbeaed1d67e4bb2a092e"
    sha256 cellar: :any,                 arm64_big_sur:  "43fbba2b7e506170bf0f03a8c281c142b04cd1b95365392d36dcc014e5f24743"
    sha256 cellar: :any,                 monterey:       "6866b7cf2364fada4775bb915c9ecd761ea6d909a9bc744e6b93a81796f6957f"
    sha256 cellar: :any,                 big_sur:        "f4471c0801590824b9fa2de9a5f25c14fc42dc8d87a5efcdf16144a116d5b997"
    sha256 cellar: :any,                 catalina:       "0d0827679b5108d79b6bcbf8a3f1ede078d547bb1986d4b7808d6cdb77104023"
    sha256 cellar: :any,                 mojave:         "f165f79a37ac61eeb25c2f9b4756848f4c3a9ddcb7250b9de0e6cc5640b00598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8360520c0127acc397b30f0aac2213f717d37c023a2aa9a96d265a0d7b77d4ad"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

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
