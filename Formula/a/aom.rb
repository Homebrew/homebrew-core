class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.9.1",
      revision: "8ad484f8a18ed1853c094e7d3a4e023b2a92df28"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8cb9a41dca274a535e5cf7ea728a694f3e9621d97ea48fa8fd270cd5d99f0347"
    sha256 cellar: :any,                 arm64_ventura:  "7b35304138ab104ff4c05cc78d16fdd6f3a4a19393d50cab274356f0dfc72479"
    sha256 cellar: :any,                 arm64_monterey: "1274fcede1882cd3cd3f176e2a44f461e3dba57f2fa77151722774c77753455b"
    sha256 cellar: :any,                 sonoma:         "cb0a6ac49c83d5377c1fe7fdc4df43e403af231c2d6db3398b01cd70b31f1ab7"
    sha256 cellar: :any,                 ventura:        "7410d19b27f952bc12722457ea58b904a6de0416f3d7ada42cfad2b1cd67e795"
    sha256 cellar: :any,                 monterey:       "9abf106327c58ffaae970744caad8b9bdace79220ba3ecf4e47fe4eb500f6fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d018fbe0e71201de17504c3a5ed73f3499dfd36b1b07a09173e826418abd00b8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg-xl"
  depends_on "libvmaf"

  on_intel do
    depends_on "yasm" => :build
  end

  def install
    ENV.runtime_cpu_detection

    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DENABLE_DOCS=off",
      "-DENABLE_EXAMPLES=on",
      "-DENABLE_TESTDATA=off",
      "-DENABLE_TESTS=off",
      "-DENABLE_TOOLS=off",
      "-DBUILD_SHARED_LIBS=on",
      "-DCONFIG_TUNE_VMAF=1",
    ]

    system "cmake", "-S", ".", "-B", "brewbuild", *std_cmake_args, *args
    system "cmake", "--build", "brewbuild"
    system "cmake", "--install", "brewbuild"
  end

  test do
    resource "homebrew-bus_qcif_15fps.y4m" do
      url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
      sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
    end

    testpath.install resource("homebrew-bus_qcif_15fps.y4m")

    system bin/"aomenc", "--webm",
                            "--tile-columns=2",
                            "--tile-rows=2",
                            "--cpu-used=8",
                            "--output=bus_qcif_15fps.webm",
                            "bus_qcif_15fps.y4m"

    system bin/"aomdec", "--output=bus_qcif_15fps_decode.y4m",
                            "bus_qcif_15fps.webm"
  end
end
