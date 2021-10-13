class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.1.3",
      revision: "ce9a40ce01ade9d6fea1721c82645804a2f39b00"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6e289d13b26ea36b824c282e2dda13182d044769e5de4808cc6b400f82893f3e"
    sha256 cellar: :any,                 big_sur:       "a1137d103b78465922ecf9dac575c559ed764cda3067e3450dcb9074e761ff73"
    sha256 cellar: :any,                 catalina:      "d94727375093bf891d34248f9d7aecbe2ce690bebe85fe7f3b876e1ed682e404"
    sha256 cellar: :any,                 mojave:        "d6af55b723ccfc6ff17d3d4df30d47076b8ce5aebeafc65fde4b2f53b956fce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdebdea0ad7dbe01b3aa89d268ef8ac63a712a5dced295d6c68b276240d9c6b7"
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
