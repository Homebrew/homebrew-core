class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      :tag      => "v1.0.0",
      :revision => "d14c5bb4f336ef1842046089849dee4a301fbbf0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdcfd3f69fbf8c9d5d3277a9cc0aabe6e4d708e3c505724828078ef93d3c82f7" => :mojave
    sha256 "7ab120d51096c0b9211588e0241f6e3da2cb76487fa92ed3fba97ccefab6608b" => :high_sierra
    sha256 "6059c30278e7c195ca7bd6487e21b7f8177d1320c32ab7d1e3202649b4680a3b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    mkdir "macbuild" do
      system "cmake", "..", *std_cmake_args,
                      "-DENABLE_DOCS=off",
                      "-DENABLE_EXAMPLES=on",
                      "-DENABLE_TESTDATA=off",
                      "-DENABLE_TESTS=off",
                      "-DENABLE_TOOLS=off"

      system "make", "install"
    end
  end

  test do
    resource("bus_qcif_15fps.y4m").stage do
      system "#{bin}/aomenc", "--webm",
                              "--tile-columns=2",
                              "--tile-rows=2",
                              "--cpu-used=8",
                              "--output=bus_qcif_15fps.webm",
                              "bus_qcif_15fps.y4m"

      system "#{bin}/aomdec", "--output=bus_qcif_15fps_decode.y4m",
                              "bus_qcif_15fps.webm"
    end
  end
end
