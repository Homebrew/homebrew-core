class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "c4711c5062dd6477454f4aa481fd8c37497ec08b1a8fd5f56c85ca6559b86824"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8bb68585191f4009a653ab95fa3042a0aa4cb06a8c5cd198b63edef566b9d07c"
    sha256 cellar: :any,                 arm64_sequoia: "79cc5a83ecb8678bd8f82f3ef8e33a7cd328686486a8fe915c679073ce22eade"
    sha256 cellar: :any,                 arm64_sonoma:  "936dd019aab13848ec04c05d9d6e1e75ac86a46fa7cd5afde816a87a01eb437c"
    sha256 cellar: :any,                 sonoma:        "8208123daf6f7544102340aff790079ffaeeed49619e18386bd09158541f3989"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "288e776e37cc4e5f4c5950d713af17985146f80bddab5b7a74fc05014a6c37e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47caa6b44ca07af8905fed0022de83e030b2d2ea2119b0a16bb8b005704ff6e1"
  end

  depends_on "cmake" => :build
  depends_on "librsvg"
  depends_on "libusb"
  depends_on "qtbase"
  depends_on "qtpositioning"
  depends_on "qtserialport"
  depends_on "qttools"
  depends_on "yaml-cpp"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DINSTALL_UDEV_RULES=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"config.yaml").write <<~YAML
      radioIDs:
        - dmr: {id: id1, name: DM3MAT, number: 2621370}

      channels:
        - dmr:
            id: ch1
            name: "Test Channel"
            rxFrequency: 123.456780   # <- Up to 10Hz precision
            txFrequency: 1234.567890

    YAML
    system bin/"dmrconf", "--radio=d878uv2", "encode", "config.yaml", "config.dfu"
  end
end
