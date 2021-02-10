class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v2.0.2",
      revision: "cb1d48da8da2061e72018761788a18b8fa8013bb"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_big_sur: "40ff3aca3a017ec17da8b1e259d6d73279eb05d04d88d34da67363187a9a7706"
    sha256 big_sur:       "630f7667afa820f812e6db647a35daed6a0c178234e9d021f327e77209d291f6"
    sha256 catalina:      "0ff8bc71b78e7dab72a5f51d877c4566e8933308e282e4225fb30d9858d71a3d"
    sha256 mojave:        "d53d69ac2b2a129d20322b3c994d3e3491bc669deb08d46c253f43ec8b5e145a"
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    mkdir "macbuild" do
      args = std_cmake_args.concat(["-DCMAKE_INSTALL_RPATH=#{lib}",
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
