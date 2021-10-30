class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.2.0",
      revision: "287164de79516c25c8c84fd544f67752c170082a"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35494aa84690adb7953de9a6a83c4438709711e3bf4c35a15932d24d9560c954"
    sha256 cellar: :any,                 arm64_big_sur:  "9f96e16080d85a7ddf79e6d589a54b0fae4d66a397a417e6aa20ca923e52df54"
    sha256 cellar: :any,                 monterey:       "d68bcac8c90d2482c9563d2e2c280dc19dcdbc2f9ba44053f8a6301aff6b9c31"
    sha256 cellar: :any,                 big_sur:        "6032353c0bd07cb5bd4d94696c224d4d6d46315fe809239590f202961d22dba8"
    sha256 cellar: :any,                 catalina:       "4ccf3a3b28fa2f8dfee933b3e70eac65f2dfb1d4b1ffed8731941687749ea4c3"
    sha256 cellar: :any,                 mojave:         "a597f10374d065108ce767d7256fefa673bc665439ad4afb35ef4cc02a6e1848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "446a3c0ca883c00a6870c38f1900b745d088accb2bcde750d5cc1f9ae7599be7"
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
