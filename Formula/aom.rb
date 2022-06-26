class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.4.0",
      revision: "fc430c57c7b0307b4c5ffb686cd90b3c010d08d2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f16849b3bb161a0695d5bb6677799f4d87e1db60fbaf6719f1ea0a996847d029"
    sha256 cellar: :any,                 arm64_big_sur:  "d73c1ddd2cfdc4c53f6362b5bbbf70a6f127d5eeae5039e77a36b6fca5bcfd92"
    sha256 cellar: :any,                 monterey:       "a06dca8e5ce52a095f6aca1dbbc5c1840465b16f7935f671e1eb0139479ccec9"
    sha256 cellar: :any,                 big_sur:        "ba4000b61ee2966a7064fc98aea0e5f8ae231dd249edc352fb27e01756c6cac6"
    sha256 cellar: :any,                 catalina:       "9d64c9e660e8b21ee46544e7542eb642590d1f3da72c8d107f3b3b74b362d978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1824239b9ffaf9235c1bc73c6dddd8c53219bbe5a5bf041a143bf54c7ed58518"
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  # `jpeg-xl` is currently not bottled on Linux
  on_macos do
    depends_on "pkg-config" => :build
    depends_on "jpeg-xl"
    depends_on "libvmaf"
  end

  resource "homebrew-bus_qcif_15fps.y4m" do
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
