class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "8fb2d1aa3a0de50222f6286c47220a5bc7b73708b60fb7d58f764deebd43d82d"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "4ea5de1bb729263aca9cd5a02f905bce83f33cd254066092f7743ddf8eee71f7"
    sha256 arm64_ventura:  "78f4b3627bd8442931c6eb2aee3710f9e85440797401e111c0026e681e287e71"
    sha256 arm64_monterey: "c39f654334abcaca0a6f06be85d10e84e1e11f17d87a1604c18c7e166d5b213d"
    sha256 sonoma:         "e9a77b3de0e081a047a27bcc61a998ea29f8f405865563a8221f0748df31cbb0"
    sha256 ventura:        "2ff894e1bbcd97e5e503e248fa3531484d0c78acf89516ceeca947877de888db"
    sha256 monterey:       "fb2c87e13038d1e85d50ebc0981803684d58105253ed6eaf96b92ca13bfb596b"
    sha256 x86_64_linux:   "6ba7e9b4d370b1ff5165c94f716e3a97542747da12ff7083d3bf76b75e42f24f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    version_output = shell_output("#{bin}/openFPGALoader -V 2>&1")
    assert_match "openFPGALoader v#{version}", version_output

    error_output = shell_output("#{bin}/openFPGALoader --detect 2>&1 >/dev/null", 1)
    assert_includes error_output, "JTAG init failed"
  end
end
