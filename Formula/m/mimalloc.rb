class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "6a514ae31254b43e06e2a89fe1cbc9c447fdbf26edc6f794f3eb722f36e28261"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d5460e154995c00c5797300a572f0c8c39ecfd16b1813823e63f6448ae53572"
    sha256 cellar: :any,                 arm64_sonoma:  "b6eb2a1023d020f84b00a2437090dc36cb11e21d816ae0a2a003a8b49bb7d3ca"
    sha256 cellar: :any,                 arm64_ventura: "a04b923fc266ca31776d4688c311741cbc2781e791c1cebae5fbf9fb7c99ebb2"
    sha256 cellar: :any,                 sonoma:        "de49a7a337b9c70b83a4868456579ad04b91ea7999ed290e8019615f877ef496"
    sha256 cellar: :any,                 ventura:       "f0363fcc3261c526dafd2ec80ba2a0e4629f3029a51ca2c977ad333b5cadcae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d24f6413b70fadc239b156e15bf5a7cde0b587d46d63c1feb6ce5369fe832785"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", "-DMI_OPT_ARCH=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end
