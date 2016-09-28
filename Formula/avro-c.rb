class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.1/c/avro-c-1.8.1.tar.gz"
  sha256 "e5042088fa47e1aa2860c5cfed0bd061d81f9e96628f8b4d87a24d9b8c5e4ecc"

  bottle do
    cellar :any
    sha256 "baef97c134a8b14fa6cc162ad1321561ca3f1122ab95f42149e7058f2dbe722e" => :sierra
    sha256 "e572f37156e85db6e008fc394c7cb09fc5ff87c6a8a3f9f55d38f38f2253cdd9" => :el_capitan
    sha256 "c84beca0ab8defc026fccb3eecc77b26523014f64f7d377e195f8906622beba4" => :yosemite
    sha256 "ba3f6ab12df1ad13ec5aa04a038f4e4d4823c671bfb0f65b50d7015488db346e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "jansson" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
