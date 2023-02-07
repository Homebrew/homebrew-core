class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.6.0",
      revision: "3c65175b1972da4a1992c1dae2365b48d13f9a8d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5e1e6e6885424f0a37072048e988338cc54874fd960ab6b75461e3d2b1da25f5"
    sha256 cellar: :any,                 arm64_monterey: "8dadf43f156f53d166c4a62cc09fe8a19f85f8656c8727789c775da2e8e7a440"
    sha256 cellar: :any,                 arm64_big_sur:  "58d593da4c7d1d0989d3420cd86efbd9c5b755d92a381c3a2476ccea91ac8663"
    sha256 cellar: :any,                 ventura:        "13c46d4e8667308ed0054ef2a39332c156b431386ccbc3fbad7ec35b4b2b3858"
    sha256 cellar: :any,                 monterey:       "c968ba6f3d7b9010ce712348522aa1f94d9d8a9eda396bf27ffcd1bf96d97894"
    sha256 cellar: :any,                 big_sur:        "11a8259378ab8010e17ee1aa433beaf20ebdce3acf0e2eae9887eb81f6c87dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd1a0c968f789acc8676f7abae22dc9d4e81098f72afd0167f3ad9e9b7412eb"
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
