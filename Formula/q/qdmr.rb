class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "245809ac742e30085d94bc77386c65d78ff36961928e83eca68c0f1850b5a30a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd583c92c811ef5987c9aac0f84ec2d0ff53677d742c2d4ad937f311e024a632"
    sha256 cellar: :any,                 arm64_sequoia: "190512157270fb5abba205eb70d0f77367d3a311aef33e6013b81af3eaa3c16d"
    sha256 cellar: :any,                 arm64_sonoma:  "108e24201da697b83caffbfe3d9dead14e661b116ab4cf1d5a4103deabbf6a65"
    sha256 cellar: :any,                 sonoma:        "cdc763a25998acc68dda905b14fa26aebe8ba8b553e8b49a2d1cfdf2be2c5f10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08521d3fea0a0632c7beab4631b8433c96ffd119c14f53e788ea2ac2e1f3f648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c34c062cec9ea3bba962e5ed198fc463b7338aa77e8d4b35dc8356a5ac25460"
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
