class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.11.0",
      revision: "d6f30ae474dd6c358f26de0a0fc26a0d7340a84c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eab56b62a34fa519427a4388055e3f1abe244aebfaaebbd3e7eeb6a2bf770b87"
    sha256 cellar: :any,                 arm64_sonoma:  "02f671d324c3073b89bc753c96d2bb2e0ea79520c4ebe7354bec355eb9988b46"
    sha256 cellar: :any,                 arm64_ventura: "a6d544883fdf924adca547941499685e5e7340a1b7e6e485e1bbfc1bdbea563c"
    sha256 cellar: :any,                 sonoma:        "14d14953b41129d9c6ec2beb5e5d36b62efa05c3a6af8ef8f8804264c8901204"
    sha256 cellar: :any,                 ventura:       "73666ba2ebee2685d2bcea0af94d9208b8147d35108bb3834bacd41060f23b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32716bca18edf78819253b2cc58279af4e021977de36fe1109dd3dd9c53d9166"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
