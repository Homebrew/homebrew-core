class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.6.0",
      revision: "3c65175b1972da4a1992c1dae2365b48d13f9a8d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a42b91d504001259b899320777fbd7890d2bbb658c72be7877cc8473c26f8b13"
    sha256 cellar: :any,                 arm64_monterey: "82c42edfcd3aa2efd0073059424a80d5a38fe48db5a387a2b18de84a77c82512"
    sha256 cellar: :any,                 arm64_big_sur:  "f6a3f0cd52dd7bbf7ce6dde8880e3c3db9144c2891f012a9e5ce8e392c071d0f"
    sha256 cellar: :any,                 ventura:        "d01cb23d675b8706f7ea5c889d2b6dc223c54f84d2b2a496930dcf5d7c725b29"
    sha256 cellar: :any,                 monterey:       "cecafb1aa837a007e2cde5907515492d059b8bfd4d64983bc4f116edcaa65726"
    sha256 cellar: :any,                 big_sur:        "3e9ca81ede28cbf3e09e0bca5d7af4529f72d9a27202e7e759ce7f62b0c0b02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd6938f444ac758c20caa553b64dbfa4cdebd60b6e572d08b0be69a704599f35"
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
