class Lzws < Formula
  desc "LZW streaming compressor/decompressor compatible with UNIX compress"
  homepage "https://github.com/andrew-aladev/lzws"
  url "https://github.com/andrew-aladev/lzws/releases/download/v1.4.1/lzws-1.4.1.tar.gz"
  sha256 "2a15efeb955201b3ea459cb3fc29d3a50cdb0bd8743e344c96f76b466bcefc48"
  license "BSD-3-Clause"
  head "https://github.com/andrew-aladev/lzws.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gmp"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %w[
      -DLZWS_SHARED=ON
      -DLZWS_STATIC=ON
      -DLZWS_CLI=ON
      -DLZWS_TESTS=OFF
      -DLZWS_MAN=ON
      -DCMAKE_BUILD_TYPE=RELEASE
    ]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_equal "sample string",
      pipe_output("#{bin}/lzws | #{bin}/lzws -d", "sample string", 0)
  end
end
