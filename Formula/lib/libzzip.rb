class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.72.tar.gz"
  sha256 "93ef44bf1f1ea24fc66080426a469df82fa631d13ca3b2e4abaeab89538518dc"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "6e4b8f01f66f4c21a3b6467e1dfebad5e5a204db29b4dc13b448adc0e754419d"
    sha256 cellar: :any,                 arm64_ventura:  "ee5a0f4f19686b63534c718d9c61d75a2a3b1f2ef3b4bcd6be5615536cc84c5d"
    sha256 cellar: :any,                 arm64_monterey: "ac7b8f35398634a9092daddca8a30508bfdb1925407f8c8f6fcdd6e69e43f9ef"
    sha256 cellar: :any,                 arm64_big_sur:  "e2594d07e6b05062c3c28341225052a5ca2f4bd3dc900fc20f3e94190273d548"
    sha256 cellar: :any,                 sonoma:         "29059d07df1a98967e48d507db2693c936b0b348d9bfdbf832cd66f96c4bb0f8"
    sha256 cellar: :any,                 ventura:        "5feaf45ca387319476e60f2e6bfd8ff2c9dda497df6c809186166e5af098bd22"
    sha256 cellar: :any,                 monterey:       "7b2db8ae12f457c61a4191acf807936608aa4cb8b036560e534d83b50602fd67"
    sha256 cellar: :any,                 big_sur:        "d7a969de7fb5d84796d73f5bda8c53fe044c2808caece9a5f6e20e40201c3860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1faea53bbda32778a2056db47a71ea16c02c476382770fa2c928663fc869734a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "zip" => :test
  uses_from_macos "zlib"

  def install
    args = %W[
      -DZZIPTEST=OFF
      -DZZIPSDL=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
