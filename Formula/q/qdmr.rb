class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "209b41d38ee228760ebe50fce0ecaab42aabbdd22872e0437c32799736eab2b2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "32df27547416b1d925fcf0e6aa83a7da815c3c5713bf8fd79192bbe3f118738b"
    sha256 cellar: :any, arm64_sequoia: "8dd895f0e54072b336dd3b75f1ded5fc93f3eae9bf949f886ba0207401ff5b5b"
    sha256 cellar: :any, arm64_sonoma:  "eb4a9ab5a671ea55d2713029f137d68f01da1b50bd894e3a6cb1dd90f6c8aa8d"
    sha256 cellar: :any, sonoma:        "32c6dc8731628a6ae0ec2236ff161ff9d40f5b5f9b5797cc2a7e90cee9c5c467"
    sha256 cellar: :any, arm64_linux:   "4bd128e2d61093bb78b400942e8387320584af8f110133475e8e2d364f63ac11"
    sha256 cellar: :any, x86_64_linux:  "2a3643b0eead3cddc4a90c89f1cfa343254ffd8574696702b3d260280dbf1684"
  end

  depends_on "cmake" => :build
  depends_on "librsvg"
  depends_on "libusb"
  depends_on "qtbase"
  depends_on "qtmultimedia"
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
