class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "63fd6b2061ebcfee54fc1c6df77e21484a544e694723725b70b49ca4990138d3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c547aa11b729f98207cd3ca10da2684f113299c61096d876370cebef4d122871"
    sha256 cellar: :any,                 arm64_sequoia: "1808f9a6971ecac365fb1d9f6a4ff3c739c7a19ef6865d27d6ca38c8f031f46f"
    sha256 cellar: :any,                 arm64_sonoma:  "17c82b226c07ad4f51aeefd564319c874f4024839dafa83cf5c3266ad42ac5ab"
    sha256 cellar: :any,                 sonoma:        "c25f5ae2f77ba6a208a2924d14e406f54af3f9adbcf579544a99cc615a386c75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f816ff55ab36371cd96c0b2a4846ceb6e88388952e06589b9e3c6b93594f933e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57a70dfa8b56f6653f105784cee83c46cbf73d8c7fbb29f30d11338463a3986e"
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
