class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.6.1",
      revision: "7ade96172b95adc91a5d85bf80c90989cd543ee8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "966c8e8e10fb914ce2d6272e6f44fa6235010914bd6e1b40a6a77516bbf92949"
    sha256 cellar: :any,                 arm64_monterey: "c0a1489fc018dc1a62b3668940b84bc302448d14d231500f5181fe70f742ae9d"
    sha256 cellar: :any,                 arm64_big_sur:  "05e2be27ea35bb4393fa9e135997631163a0e03f7553b38bb2ef74c216898583"
    sha256 cellar: :any,                 ventura:        "130033d7682e4cfa135ea1bf441f8fa661d55ceac06be2059667bc3506f88e78"
    sha256 cellar: :any,                 monterey:       "ecc7821e3e1c4aea91f74229abc28d360fda9bf9f620a048b26b85ef1d7c5523"
    sha256 cellar: :any,                 big_sur:        "acab19ae318c71f1c02c99fb60a2743a84396cb6cf53c51dca5f96bffdcc1971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a80ca6ea6a96f353ec73175886f26d73652dbdf1a50f104b81d0775a442df24b"
  end

  depends_on "cmake" => :build

  # `jpeg-xl` is currently not bottled on Linux
  on_macos do
    depends_on "pkg-config" => :build
    depends_on "jpeg-xl"
    depends_on "libvmaf"
  end

  on_intel do
    depends_on "yasm" => :build
  end

  resource "homebrew-bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    ENV.runtime_cpu_detection unless Hardware::CPU.arm?

    args = std_cmake_args + [
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DENABLE_DOCS=off",
      "-DENABLE_EXAMPLES=on",
      "-DENABLE_TESTDATA=off",
      "-DENABLE_TESTS=off",
      "-DENABLE_TOOLS=off",
      "-DBUILD_SHARED_LIBS=on",
    ]
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
    resource("homebrew-bus_qcif_15fps.y4m").stage do
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
