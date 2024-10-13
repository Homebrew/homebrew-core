class Qdmr < Formula
  desc "Codeplug programming tool for DMR radios"
  homepage "https://dm3mat.darc.de/qdmr/"
  url "https://github.com/hmatuschek/qdmr/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "309854ba81c7b59a748e42958eb0acbd4b5efbd956790ffdf04886c9abc6c588"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "dfd2e1ef58019f2cf0edcabedcc8d0559bb014478e349bdd4e32128f1d641f40"
    sha256 arm64_sonoma:   "c61719e66046cf2dc2995949e48c56fbc9b8e7aa1687fee3fc2dd279f7639eb5"
    sha256 arm64_ventura:  "76f4b08ec605a1e316c08c7f99eb82280ee9a6bdad2f13e4ad846d7eb7aa1551"
    sha256 arm64_monterey: "205f2098198e0c5e861bf5612c6f5d227baad54f63fd950e98fe92d485dc3196"
    sha256 sonoma:         "18c109314f78f38164ae6bf00eeff1b7f98183c371e3d301da6e0cea13114dd5"
    sha256 ventura:        "9fa82f7039cc7b94b645db9d7031a73faee2316785a4960bdf75329f308dabd8"
    sha256 monterey:       "22b7f99b5fcb8b06744c3a97ea85d86f7abf51682f7988b236e7391dbf5c41ec"
    sha256 x86_64_linux:   "774c8c6089066641a4abd1f5fc28d563feac0a1fc66aedcb192f636a8135b3b4"
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
