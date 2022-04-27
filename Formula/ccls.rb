class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20210330.tar.gz"
  sha256 "28c228f49dfc0f23cb5d581b7de35792648f32c39f4ca35f68ff8c9cb5ce56c2"
  license "Apache-2.0"
  revision 5
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "b36865e44b2c069bbbad41af547a3fd1bbfe6f4054888468510385cdf5dab36f"
    sha256                               arm64_big_sur:  "1075fcd39f1813404abce39f2eca51687e3e72977a96cae4de26e48b3e6591c8"
    sha256                               monterey:       "d7a6c89c99636f2def2692067c875a136337ef4d40ecec8758487567dcb8c3ac"
    sha256                               big_sur:        "e481a75f3d70938638da8e88205c92f4a0bea717d6d637d8c7f270815d0f79dd"
    sha256                               catalina:       "df3d6cd340b9462297fd684e81dceaf240b4f0b935cc8b17aeff9852ed893c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72b19499856ade5a2282a3ab9bd520ff233367f64b2bba808546cc214441ffc1"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm@13"
  depends_on macos: :high_sierra # C++ 17 is required

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    resource_dir = Utils.safe_popen_read(Formula["llvm@13"].bin/"clang", "-print-resource-dir").chomp
    resource_dir.gsub! Formula["llvm@13"].prefix.realpath, Formula["llvm@13"].opt_prefix
    system "cmake", *std_cmake_args, "-DCLANG_RESOURCE_DIR=#{resource_dir}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ccls -index=#{testpath} 2>&1")

    resource_dir = output.match(/resource-dir=(\S+)/)[1]
    assert_path_exists "#{resource_dir}/include"
  end
end
