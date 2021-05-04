class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.1.0",
      revision: "c0f14141bd71414b004dccd66d48b27570299fa3"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "e0571295e7c45b346677673f1ca8e4b62cfa1f17ef070c225fa8251b707c1f11"
    sha256 cellar: :any, big_sur:       "67a3761a41430e4c3b314d7c6b02225682e3907fd476b38b2e3fb736c5006e3c"
    sha256 cellar: :any, catalina:      "57b3be90bfbebeb28f29c64ee2a9c0d0c520827ed0f879f89280bb60cfc5238c"
    sha256 cellar: :any, mojave:        "9c8b6d66053c671b354ef7ba62f244d8ab0d65b4409f6c0798db1c22594cee49"
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    mkdir "macbuild" do
      args = std_cmake_args.concat(["-DCMAKE_INSTALL_RPATH=#{rpath}",
                                    "-DENABLE_DOCS=off",
                                    "-DENABLE_EXAMPLES=on",
                                    "-DENABLE_TESTDATA=off",
                                    "-DENABLE_TESTS=off",
                                    "-DENABLE_TOOLS=off",
                                    "-DBUILD_SHARED_LIBS=on"])
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
