class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.13.2",
      revision: "ad44980d7f3c7a2605c25d51ea96946949000841"
  license "BSD-2-Clause"
  head "https://aomedia.googlesource.com/aom.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f7d487cfa6a180e94cd61ac0f43e0f56c4fc77137c5177d40e968b997ded27e"
    sha256 cellar: :any,                 arm64_sequoia: "11ab02be9537cafffc55517adcafb13ecf9b428db4a9623a0263654a54bd96c8"
    sha256 cellar: :any,                 arm64_sonoma:  "6bd59479eef3fb502cb579f6118a0180b56a2ddc48b6aaa772647b05760b9193"
    sha256 cellar: :any,                 sonoma:        "4b92c1d88139c2f1687b297f163b490394dbe458c0ed57f046f1f1ad1f8230e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d824fb52b8e354a5aaf863a93b7d92522617adb8bcde5cc262d212c52dc8dd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c48b965f8469558c5e27497a9734559484ae83521b6d499e42c9838fa017ba67"
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
