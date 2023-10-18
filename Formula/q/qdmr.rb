class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "bad499faec7533c460e72c121716141f8cca0ea613ed55143ba1780b06a49b9a"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "9f2e10e7aaa0af1d6530358f840f53f5e28c8fe08a391b92fd39ee9b59cf20ea"
    sha256 arm64_ventura:  "a3d47d1a4f74f29d7205b551e09602e0d7459677f25653fc788e3bf8fe3cbd6f"
    sha256 arm64_monterey: "b825f13edb4f363391a354ff6c99b1f117dbc07ea222804ddeade267642fafc6"
    sha256 arm64_big_sur:  "e24d6e79da29b3e49aa5e727b89aa6c41cfc8d87d6d731576ad643507701a867"
    sha256 sonoma:         "2980a84c67bf0bf683c97a3bfc94d2f446dbb73ca0f69c11e355bab2e83776ec"
    sha256 ventura:        "96a334c4673dd26658fac496c7788bb27f4efcdf0b1bf8f2b720888a435e2cbb"
    sha256 monterey:       "7702c73879f9acdbab76b3fdfa684533f674a6b36f35ed23ae91ae1c983f73a7"
    sha256 big_sur:        "0115dad9c598ae7fd2ebcf0127d5daaf87db0bb324698ff99dd6e8e9d3c99d86"
    sha256 x86_64_linux:   "f63dfccf38fe9a7542be3adec7d0ca85777c566a8a92fd3a9e5f527ad8db270e"
  end

  depends_on "cmake" => :build
  depends_on "libusb"
  depends_on "qt@5"
  depends_on "yaml-cpp"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DINSTALL_UDEV_RULES=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"config.yaml").write <<~EOS
      radioIDs:
        - dmr: {id: id1, name: DM3MAT, number: 2621370}

      channels:
        - dmr:
            id: ch1
            name: "Test Channel"
            rxFrequency: 123.456780   # <- Up to 10Hz precision
            txFrequency: 1234.567890

    EOS
    system bin/"dmrconf", "--radio=d878uv2", "encode", "config.yaml", "config.dfu"
  end
end
