class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.1.0",
      revision: "c0f14141bd71414b004dccd66d48b27570299fa3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "42d5b42cfd577ec6c05cc6db35241e129841ec848acb32dfab2b8e9106213f63"
    sha256 cellar: :any, big_sur:       "b01451365abb2da2a9b17d2aff9fba994e90b37183a946c6bf70acd8f4fc6a2a"
    sha256 cellar: :any, catalina:      "45c28e95a7e3753c21e8fcea18923c554ee62df7c9b44c93c077abfd65adf8c2"
    sha256 cellar: :any, mojave:        "09ae7034b69c0c07696ebce9a8d04131b8395abb755a365240d1f92d60ceb2c8"
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
