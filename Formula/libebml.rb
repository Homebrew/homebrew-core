class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.4.2.tar.xz"
  sha256 "41c7237ce05828fb220f62086018b080af4db4bb142f31bec0022c925889b9f2"
  license "LGPL-2.1-or-later"
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fce6d01b12243501223e4e9294528b8eab1818815b18e4ffe777fd14cec0e525"
    sha256 cellar: :any, big_sur:       "de4edaae6d3f42a388be996f448b582262e39e923acc9ccef881a20ffa817d38"
    sha256 cellar: :any, catalina:      "20a71bb0c2babdc04f179dc77c7a03c2f2f2031e7d8d87fbf9d3c41ee831addc"
    sha256 cellar: :any, mojave:        "c3c91dc9f86978012a06f299115bc088e5ea0af6aec2e915d0f8338c4c0edd03"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
