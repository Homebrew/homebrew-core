class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.3.7.tar.xz"
  sha256 "e3244c87f584d7fc8c371881a6b7b06583cc041f88e2e3fae9a215d9ca58e9f4"
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
