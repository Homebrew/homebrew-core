class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.13.1",
      revision: "d772e334cc724105040382a977ebb10dfd393293"
  license "BSD-2-Clause"
  head "https://aomedia.googlesource.com/aom.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "518aed50b3ab63ef4d9b7cefcfaf257b683f247f06dd81c173c7e5df03bd9d5a"
    sha256 cellar: :any,                 arm64_sequoia: "ca79133eb9a4ec1e943322ef475811cc2be310cccfc28d4aa1326bfba0ffa0c7"
    sha256 cellar: :any,                 arm64_sonoma:  "697ad35de4a11f4a9f8a7307384081a397ca58ff238060a396e1248e88a08b24"
    sha256 cellar: :any,                 arm64_ventura: "9329b9bf9dbd64be5bf52ad5eb822e0a7454948bfb91746772e0ee2788ae70e4"
    sha256 cellar: :any,                 sonoma:        "5d05040b86a95990ea50468ff17b5cbe3bccb2e636a1f6256e4c0439fe189f93"
    sha256 cellar: :any,                 ventura:       "644685d7962c133de1873d831d87a6cc71138fcbf2bbe2455b51000011a72b3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfb1ae4c7df80a5a2a6df56e1eef67536da73f1c90601d96c637e6a871ed2635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c860bd13961bfa2cba27db91983d7bfac46e9a00ae005174ea6faa41bce43969"
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
