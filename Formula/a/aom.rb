class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.8.2",
      revision: "615b5f541e4434aebd993036bc97ebc1a77ebc25"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fc312c24fe4358237a2aa3359440f9c369d69294f5bc430c4335b9d7a05d6fe8"
    sha256 cellar: :any,                 arm64_ventura:  "c74c13e3945e69a4cb2f6da6155ab9a2ac5922628a87543a6edd34cf7f9c9964"
    sha256 cellar: :any,                 arm64_monterey: "133e39d2ea6abc7a1bb2f17c8cabfc64f0e46756104ce3cb4b4ecfed66436bc6"
    sha256 cellar: :any,                 sonoma:         "507d9e5a86a0a2c55b3636312f657cb1a570a59fef4a3279c6785ada1ea48e02"
    sha256 cellar: :any,                 ventura:        "d3016087ed47320f1bf7c80a93a2f31296bf91221161b40a95b21b1a4f751169"
    sha256 cellar: :any,                 monterey:       "6e65d1d767ac467a07571635d8f02ba84f9871632d455d9ef1b90a2766157d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5a0094640b70fd32e4ca9a4b5d8f5ccaac1d651f50be8cc34cbcd44155ca742"
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
