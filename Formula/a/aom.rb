class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.10.0",
      revision: "c2fe6bf370f7c14fbaf12884b76244a3cfd7c5fc"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8ab0ca54bc4adb96a43fefa315e92c391855b1d9eeaa44f17d4cdb3421aebd08"
    sha256 cellar: :any,                 arm64_sonoma:   "64ae34cc94bd038a3c2072757a794b5eb04084a937fba9caf522c8a752454c14"
    sha256 cellar: :any,                 arm64_ventura:  "3c9b27fc4d94f24bde45494301863ee458a04cb8784889b8232b43ae9e56ccde"
    sha256 cellar: :any,                 arm64_monterey: "ab03b82135121d0d4ab152e931756a9d729e0505b4de4c0b05ab0a0c4105d1ed"
    sha256 cellar: :any,                 sonoma:         "4afef28e07f9cc1d2699e7ae07c119c4976426319f45ca793cfcee7f4385913e"
    sha256 cellar: :any,                 ventura:        "50b74c67ec12634418b728d8512319f25faa0a3b1de843493e62dc227ce09f83"
    sha256 cellar: :any,                 monterey:       "18d2b34abcb8f422e92b865d9f19a933cf0404ea60de00223764077132a4657f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c56432707c34c7e475827872031754611aece7ad575c957e5b96f732580778c"
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
