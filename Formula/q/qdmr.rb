class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "cb584c500f98897a959d7242292261ae7d8deafc7d0f709fc53d811e40d27f11"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b503002f09b4cfa8641ab1216d64442f89ea122fddd22763c66a64ec4302003"
    sha256 cellar: :any,                 arm64_sequoia: "d8955c28830bcc49c18f908658e27ca77c148edc73e57d0b70ac08fb7ac78cb8"
    sha256 cellar: :any,                 arm64_sonoma:  "428503859864e597728d26431a6e0e44209dfd679dd779be8b829c632d6b06e8"
    sha256 cellar: :any,                 sonoma:        "5d09662a536662b434ac7aadefae20e2760056b088a44fd4003ef2c059b132f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0caee5a51c5a3f0b686f2aaa901096540bea72a9bed40b4bea970ce2bf44b839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd115844dda55a26b9078c1f07732e2ab6592afeaca4fe4cf80fdd75c0e2f19c"
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
