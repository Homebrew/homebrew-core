class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.1.1",
      revision: "7fadc0e77130efb05f52979b0deaba9b6a1bba6d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dafc3da3568a3faf64f1fa180176de062fb2e5872bdebb89e6162cb606e411fd"
    sha256 cellar: :any, big_sur:       "f8b17942fbb271c70fbe122f0937cd446acd7f86bcd792668f64fbcfb51d5e96"
    sha256 cellar: :any, catalina:      "839bce0f6c0f486583dae83b50c154272b34dc9bd06bd6efd5a43f4fc91a63cd"
    sha256 cellar: :any, mojave:        "80ca7af4ba75bf8c0ae577eb66bfaf16e7cd564c16f0639c6e50df1427fd6452"
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
