class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.4.1.tar.xz"
  sha256 "6e94c669405061aa0d25a523b9f1bea8ac73536e37721a110b3372c7f8717032"
  license "LGPL-2.1-or-later"
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    cellar :any
    sha256 "0c02fee60d448bc4c3964cf075692af11eafcc77df26eddb4e4120bd5d5f5191" => :big_sur
    sha256 "66c6769cd2da8da5573a43d3f106b5f0218ac172171c18f3b555ea26ff8f5f8c" => :arm64_big_sur
    sha256 "37fa610470ee8ced3f88e8e2a1222323f888d3b367105f9ca52ee055f7b789b3" => :catalina
    sha256 "0dcc4f56f9b16dbc4fa84e9f79474491490948edb5f7d0a5f1243b315c2968d1" => :mojave
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
