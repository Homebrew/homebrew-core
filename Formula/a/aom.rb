class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.14.0",
      revision: "047d8cf6168feafe1300eb6902000dd1a03d5549"
  license "BSD-2-Clause"
  head "https://aomedia.googlesource.com/aom.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "72e45baf4c02b6aa2ad059dc6469d7f5a0c2f087118f4089879c6319533363d2"
    sha256 cellar: :any,                 arm64_sequoia: "44eb9342758b1f7dc17ee80c6bac93f316966781964902813ed39931b9ee6610"
    sha256 cellar: :any,                 arm64_sonoma:  "c73438ff1056315ffb2eedd1a8e6e31a78242090d5d5f9519c4fa556f1e854e5"
    sha256 cellar: :any,                 sonoma:        "0ef9d87db1682476846d69e6fdcef03c296efc4896bfe7bd100c2d93c841a252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8078a6f9d17db9ec9e4bb522deb266bb61411c4b14b8d109921af147df43a88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3663e4528ce21efa8f1d7dac9e3e1104f054db76134e1dbf01fba57c3e7c6e45"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libvmaf"

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    ENV.runtime_cpu_detection

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_DOCS=OFF
      -DENABLE_EXAMPLES=ON
      -DENABLE_TESTDATA=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_TOOLS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCONFIG_TUNE_VMAF=1
    ]

    system "cmake", "-S", ".", "-B", "brewbuild", *args, *std_cmake_args
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
