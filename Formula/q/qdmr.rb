class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "80eaadc6f817894fde6773d1b021e7a8ec051cbb774f63e6a097e21d8a56d8b5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "466b1ea108063ed50d951b3e79694867255e395d516cbb43e294cbb9ffce4ca0"
    sha256 arm64_sonoma:  "b16fb78360a1a05305e2f31dc1b6949e45271b57589b486e930bd77814d2b6cc"
    sha256 arm64_ventura: "04817d917185b0e67cd0f9791108465ac2d01b54351931c2c902725f9c17bc91"
    sha256 sonoma:        "86034b508621ad37972850dc34850dff0031e1ad7827b6ee69f60cc11e79b774"
    sha256 ventura:       "43852bc488a99f1ea2eeeb638b59c24ddb30b8d559a45e0a978b26efca56b0e7"
    sha256 x86_64_linux:  "7fbb488e9feba30be04cfa868546e46ea105bae7041549c7132a7e25eacb0910"
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
