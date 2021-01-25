class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v2.0.1",
      revision: "b52ee6d44adaef8a08f6984390de050d64df9faa"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "c03472a3e8dd38972fe30ee245dade96626c7927f511b7c39eb5b1b6f789e34b" => :big_sur
    sha256 "06d96aee6c62b57139fec871110fb0c53bbe0bea114f50ab4655dda087ae54ba" => :arm64_big_sur
    sha256 "ebac8d7473e89b82ad00046243ef47207c0823e410c4d3c40483a81324ad2a4c" => :catalina
    sha256 "99912d7dfc789ce059c33ea739f736930c40ea59ce58a70a6ee2478199b4363b" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    mkdir "macbuild" do
      args = std_cmake_args.concat(["-DENABLE_DOCS=off",
                                    "-DENABLE_EXAMPLES=on",
                                    "-DENABLE_TESTDATA=off",
                                    "-DENABLE_TESTS=off",
                                    "-DENABLE_TOOLS=off"])
      # Runtime CPU detection is not currently enabled for ARM on macOS.
      args << "-DCONFIG_RUNTIME_CPU_DETECT=0" if Hardware::CPU.arm?
      system "cmake", "..", *args

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
