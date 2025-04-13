class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.12.0",
      revision: "3b624af45b86646a20b11a9ff803aeae588cdee6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0bddb3845d42ffd3f211957b80fdf4bddce67625c99f4398677ce3eeadd97efa"
    sha256 cellar: :any,                 arm64_sonoma:  "0d2cbc41662bf14ed307f9ca405e533cbcf88e73a9f7305ae52774b6813891ff"
    sha256 cellar: :any,                 arm64_ventura: "baedc04e1b6dc35c2941b2f577d4f84042ec4a5f7510bbc2a71bef69db93ba36"
    sha256 cellar: :any,                 sonoma:        "9ad194193f6572efa27c18e0b0d302efb9fe8483d83bafc6a281f761c2f13496"
    sha256 cellar: :any,                 ventura:       "447e838844f34977fa4dff5935dcdbb68233c893f7e9428bdcb25842bb61c9b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1e5512d5c3915007133926afe44ee21a948532ffd89fe8de5c57fd05b9078fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1362797ccb23ecee16db63c90f4753612af93f6950dc1e48c08faf38433bff42"
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
