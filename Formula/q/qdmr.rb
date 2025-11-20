class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "72d93d53dcdd781fd18e6769d985caff77e13fdd21e7466c9ffec65a4b0af56f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62c635e152f647454303ea78a2a5a8f87afd78e20c1f7f45b1272ff863f5c6e6"
    sha256 cellar: :any,                 arm64_sequoia: "a9f12ca56f82fa77075ca95f489dcf040a74d3b4a03f47468ff6fbe6a192c9a3"
    sha256 cellar: :any,                 arm64_sonoma:  "df423e25ca37c145fe00820d91ac0dbe3572368e7d5061036470d268117c6d10"
    sha256 cellar: :any,                 sonoma:        "01594eff74247edbe635d495334a67cdee47141f040d88a8da29c6aec72fa942"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fb6437c169ee164e4c893e23ffc5e993925ad5f7acf04bd4d28261524b691ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9771b178d2ccb208187d14f76d535a3a996721f4f45f3303a1732c4c663ab8c"
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
