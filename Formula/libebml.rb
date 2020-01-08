class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.3.10.tar.xz"
  sha256 "c6a792f4127b8059bc446fb32391e6633811f45748d7d7ba873d7028362f5e3e"
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    cellar :any
    sha256 "ab827d4f47936ff0ac3333ca38843a5171b8bd0211ac4c1f81f7a1ba6c4d3a6c" => :catalina
    sha256 "c6b199ff5aa3980d1a296f2e3d2ec50149f3ffcca2748ecd4a31e62b470e50c3" => :mojave
    sha256 "01cec2d9346a4e154d5d92327756212527b5e3b4980882b916ca05bc0aad41d7" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
