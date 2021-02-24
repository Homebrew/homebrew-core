class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v2.0.2",
      revision: "cb1d48da8da2061e72018761788a18b8fa8013bb"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_big_sur: "f17ad0f61eef16b08826918342e88f7d180009b867467aba7307a6a495b20b59"
    sha256 big_sur:       "4ac5117ff5065d8ad5e185c98eba0b4909ea2201bd0f8b8844edf2987e85d8a6"
    sha256 catalina:      "0cad1d09aafe134daa8e24f5e346fd2766171f637b31894be22f9a80dcbbb770"
    sha256 mojave:        "1856596662ee2ad37056f4db3ac26e049be22801dade3b98f1bc4ef143a23908"
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
