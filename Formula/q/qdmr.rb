class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "c4711c5062dd6477454f4aa481fd8c37497ec08b1a8fd5f56c85ca6559b86824"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87324ac9609701024096625a5c1b7e93284d7b75bd1cd222dfe41359f504a705"
    sha256 cellar: :any,                 arm64_sequoia: "a6322509dabdf98fb9b52781c2f0bfd53ebe8ae3f16d1b89cf06bb5dba23beeb"
    sha256 cellar: :any,                 arm64_sonoma:  "4b3dc2a798b84789df966229ee393dd2749f0365b9c8b8aaccad0b76abb65ab8"
    sha256 cellar: :any,                 sonoma:        "956dcb58e3e83563b75a66ee583add8c8b94d691edaf70646c770b789434dfde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "275823955716a8a9040b1ec1dc2ea8a5bb67e236393cd17ffe61e7a5b90b0f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c311f8ae4bbf081a7d40f0f6e1c385fed8e9b0c0b010852978e3b5d58646e3a"
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
