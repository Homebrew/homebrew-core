class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.1.2",
      revision: "ae2be8030200925895fa6e98bd274ffdb595cbf6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "cab48a0f87dce96cd34be83f306c76b1b12ffdc36924f66db4e5b23c7d02ed9b"
    sha256 cellar: :any,                 big_sur:       "7caa96eb1b5ffed1e77fd7bf287b8aee925a415a462209228800ad1d18b34a0f"
    sha256 cellar: :any,                 catalina:      "8755252819aa338bb5992e88e88f13e9f0e9b6b6d4bcea909fbd772d6eb80f02"
    sha256 cellar: :any,                 mojave:        "104a6c66a752c4d245830922658adaf9b0f47a4036089141d25ca6ff46ccbe92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4445426d87356c91869cce415d85c3d8bb63cdbab52ec3696e439ffce825be8a"
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
