class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.12.1",
      revision: "10aece4157eb79315da205f39e19bf6ab3ee30d0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7187a5accf9da7614d96b6fb07df1c0b144cfb096d920e9936fa78b6fba18c4a"
    sha256 cellar: :any,                 arm64_sonoma:  "0578655f1cb179f198fc868609ed7f9131cc2d7c31f76c993f6cc4843d8bfa11"
    sha256 cellar: :any,                 arm64_ventura: "cf9e2b2e861a14756ce2fd7c527bf54003a0b0af8838cc87d428e6e5579320a1"
    sha256 cellar: :any,                 sonoma:        "8ddd7ac9825cb9b13af09e3adbd3b14c260d9d76e7d9e76c50e0a11f71e9b25b"
    sha256 cellar: :any,                 ventura:       "44aa92db669a867a7727f24da664757ae5363d32ab9f8071c61551a0db93e6e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cede9e7b34be52308ead8946d50c38145649d352b437395291eb2b6044fe713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db186588bf0e900cdd1cdc1e42eb27f5da7ceed34aeff55ec22c069c530103e4"
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
