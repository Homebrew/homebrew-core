class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.3.9.tar.xz"
  sha256 "c6b6c6cd8b20a46203cb5dce636883aef68beb2846f1e4103b660a7da2c9c548"
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    cellar :any
    sha256 "98c762c686a8565ee45a71b7e779f5021eabdd1bafa62ad1e70b723a5ebdcdb0" => :mojave
    sha256 "edd3178663b28140e2ab39ebb91d8fbfd484842fdbd7648ae38c622040737b37" => :high_sierra
    sha256 "446ff193f844a84320328b9e675fb1a3dade456031d800a00684f3c24b99a99a" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
