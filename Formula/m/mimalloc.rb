class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "2b1bff6f717f9725c70bf8d79e4786da13de8a270059e4ba0bdd262ae7be46eb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "411345a8e8b4dd9b672155ca58133743c9edb4dac449021adf4c85f2a149c96f"
    sha256 cellar: :any,                 arm64_monterey: "7a8bcf8a5fb0481b97a8c4be8152afd6917fb204d9ce2362482272762285498f"
    sha256 cellar: :any,                 arm64_big_sur:  "14839c9777790bb6c46ad389b21ef9b8c3ed53fd835bc4d7f3dd6289a4704103"
    sha256 cellar: :any,                 ventura:        "1e66c463a2cb8f0a5b33d038730747cd3ed92b4f3d95f07f8ecc74167b15f4e3"
    sha256 cellar: :any,                 monterey:       "6897ae92d27a5fdea6b80b85b98bf69221dff7cd50b1966d313a7ffa22c4cdc0"
    sha256 cellar: :any,                 big_sur:        "9434f34ab3a53b6823e4037af89b9babef2c549e8a5fe6f2c001e5157846cfac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f262f303607ec3e3cfe9cddfcc5b62a318effbedb861ef965b6ffc8cd0df09b7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
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
