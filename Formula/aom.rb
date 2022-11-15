class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.5.0",
      revision: "bcfe6fbfed315f83ee8a95465c654ee8078dbff9"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3bde7b2c3cc3529eb67664ddfc24f20a479510661c7f224c9e62618430ed37e6"
    sha256 cellar: :any,                 arm64_monterey: "8e185cf8b310b04bf065728d20f4395750b17a375278cff207c55de359ba1564"
    sha256 cellar: :any,                 arm64_big_sur:  "43b802f7fad4634272150fb042887c0f4c6931f2c1b5bca23b1f2ea1af88d06c"
    sha256 cellar: :any,                 ventura:        "831002cff4013bf05df49824fde6f8f0d48868dbb466f1e8a68e82144da337ac"
    sha256 cellar: :any,                 monterey:       "e4fa96ccd7bfc3fe509302dc4aa74255c332b4b699368d3f79b77a0122a5f27f"
    sha256 cellar: :any,                 big_sur:        "44dbd7794768445e82dd61ff04301ff74e0df85c1c5963f92c9f29fd41ded8d4"
    sha256 cellar: :any,                 catalina:       "c5800c30ad8ff3502e14c5ce40594b92636839612c0d53ed8e6c6a35d6b5f936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7aa82a6c573cb0449d33ee2aa334483daa14e8e4136721bedcc86e662a61c9a"
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
