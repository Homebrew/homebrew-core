class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.2.0",
      revision: "287164de79516c25c8c84fd544f67752c170082a"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "72b91aa7864889bf1e6e28825e78dcc4a71927518e3c7d6dbb7f530c1b3fe3cf"
    sha256 cellar: :any,                 arm64_big_sur:  "fa278187ca95fb4fb6145546465ab8a613d32dc32836ad4733c5a892497932b2"
    sha256 cellar: :any,                 monterey:       "fe7904d603f1be8d9d6df3e6588787fe21878b5bf17b6ab8b123322f4c97c938"
    sha256 cellar: :any,                 big_sur:        "fe6e3a5c3a14ce0938afade898d8fe009fcf5115a6d36d6c1a88ab32ba488b29"
    sha256 cellar: :any,                 catalina:       "96714bc74e2a9ef142f1b9b60a3af3178fb0d8264deaefd219adcafe411d5102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cdc42ff566b3919db435259d77934cafc8ecb3f1516b5bc3236b165ef2056e2"
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  # `jpeg-xl` is currently not bottled on Linux
  on_macos do
    depends_on "pkg-config" => :build
    depends_on "jpeg-xl"
    depends_on "libvmaf"
  end

  resource "bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    ENV.runtime_cpu_detection unless Hardware::CPU.arm?

    args = std_cmake_args.concat(["-DCMAKE_INSTALL_RPATH=#{rpath}",
                                  "-DENABLE_DOCS=off",
                                  "-DENABLE_EXAMPLES=on",
                                  "-DENABLE_TESTDATA=off",
                                  "-DENABLE_TESTS=off",
                                  "-DENABLE_TOOLS=off",
                                  "-DBUILD_SHARED_LIBS=on"])
    # Runtime CPU detection is not currently enabled for ARM on macOS.
    args << "-DCONFIG_RUNTIME_CPU_DETECT=0" if Hardware::CPU.arm?

    # Make unconditional when `jpeg-xl` is bottled on Linux
    if OS.mac?
      args += [
        "-DCONFIG_TUNE_BUTTERAUGLI=1",
        "-DCONFIG_TUNE_VMAF=1",
      ]
    end

    system "cmake", "-S", ".", "-B", "brewbuild", *args
    system "cmake", "--build", "brewbuild"
    system "cmake", "--install", "brewbuild"
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
